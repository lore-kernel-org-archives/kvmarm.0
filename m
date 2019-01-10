From: Julien Thierry <julien.thierry@arm.com>
Subject: [PATCH kvmtool v2 11/13] threadpool: Add cancel() function
Date: Thu, 10 Jan 2019 14:12:48 +0000
Message-ID: <1547129570-14351-12-git-send-email-julien.thierry@arm.com>
References: <1547129570-14351-1-git-send-email-julien.thierry@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 82D024A478
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Jan 2019 09:13:16 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QqbhIQ2CM2NH for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Jan 2019 09:13:15 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8BE104A4B9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Jan 2019 09:13:12 -0500 (EST)
In-Reply-To: <1547129570-14351-1-git-send-email-julien.thierry@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: will.deacon@arm.com, kraxel@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>

When resetting a virtqueue, it is often necessary to make sure that the
associated threadpool job isn't running anymore. Add a function to
cancel a job.

A threadpool job has three states: idle, queued and running. A job is
queued when it is in the job list. It is running when it is out the
list, but its signal count is greater than zero. It is idle when it is
both out of the list and its signal count is zero. The cancel() function
simply waits for the job to be idle. It is up to the caller to make sure
that the job isn't queued concurrently.

Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Signed-off-by: Julien Thierry <julien.thierry@arm.com>
---
 include/kvm/threadpool.h |  2 ++
 util/threadpool.c        | 25 ++++++++++++++++++++++++-
 2 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/include/kvm/threadpool.h b/include/kvm/threadpool.h
index bacb243..880487a 100644
--- a/include/kvm/threadpool.h
+++ b/include/kvm/threadpool.h
@@ -28,11 +28,13 @@ static inline void thread_pool__init_job(struct thread_pool__job *job, struct kv
 		.data		= data,
 		.mutex		= MUTEX_INITIALIZER,
 	};
+	INIT_LIST_HEAD(&job->queue);
 }
 
 int thread_pool__init(struct kvm *kvm);
 int thread_pool__exit(struct kvm *kvm);
 
 void thread_pool__do_job(struct thread_pool__job *job);
+void thread_pool__cancel_job(struct thread_pool__job *job);
 
 #endif
diff --git a/util/threadpool.c b/util/threadpool.c
index e64aa26..1dc3bf7 100644
--- a/util/threadpool.c
+++ b/util/threadpool.c
@@ -25,7 +25,7 @@ static struct thread_pool__job *thread_pool__job_pop_locked(void)
 		return NULL;
 
 	job = list_first_entry(&head, struct thread_pool__job, queue);
-	list_del(&job->queue);
+	list_del_init(&job->queue);
 
 	return job;
 }
@@ -173,3 +173,26 @@ void thread_pool__do_job(struct thread_pool__job *job)
 	pthread_cond_signal(&job_cond);
 	mutex_unlock(&job_mutex);
 }
+
+void thread_pool__cancel_job(struct thread_pool__job *job)
+{
+	bool running;
+
+	/*
+	 * If the job is queued but not running, remove it. Otherwise, wait for
+	 * the signalcount to drop to 0, indicating that it has finished
+	 * running. We assume that nobody is queueing this job -
+	 * thread_pool__do_job() isn't called - while this function is running.
+	 */
+	do {
+		mutex_lock(&job_mutex);
+		if (list_empty(&job->queue)) {
+			running = job->signalcount > 0;
+		} else {
+			list_del_init(&job->queue);
+			job->signalcount = 0;
+			running = false;
+		}
+		mutex_unlock(&job_mutex);
+	} while (running);
+}
-- 
1.9.1
