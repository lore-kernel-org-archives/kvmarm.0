Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCD50CCA479
	for <kvmarm@archiver.kernel.org>; Mon, 18 Jul 2022 23:46:53 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 607194CD2F;
	Mon, 18 Jul 2022 19:46:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zHdRSSzpzdgN; Mon, 18 Jul 2022 19:46:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 245844CD4B;
	Mon, 18 Jul 2022 19:46:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6EED24CD2F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 19:46:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5Y0DQrzYTLdI for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jul 2022 19:46:50 -0400 (EDT)
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com
 [209.85.216.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2C0944C75B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 19:46:50 -0400 (EDT)
Received: by mail-pj1-f45.google.com with SMTP id
 q13-20020a17090a304d00b001f1af9a18a2so5615275pjl.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 16:46:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=V+k5WNh4t1m32DC2xdn9fqss9Z9YPd/9WCm7Vf/65ew=;
 b=IKcajPEAOoIJLsaEnsE29X545rHMn3JotFea30qeq9PiH2LmRPV0e2ppAntkVs3SbX
 qNmZXVmRwcP+wgg79UgXOD28mrlAFYR4DY9Mhy2g8+P2Xld7JXlu7svBXo2lz2EgEVNl
 efo6pQEuJOxxswIoQohjFg2GOpoeduYEm342e7MOPqLd+i+sbneveien6K40mVZBcUzN
 Pj3QAC/hT4WpWaUYbdY5isGpRQUYYSuWP+E0ef0pCKjBbEf98jANV0nrgifcXwD5DiT7
 osgc7gmGlWp3JNod5zpKbBzHK6DX1aWKdw/6HxZAxmcE2ke8+yE34zvOVgup4RY8O8K9
 +ydQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=V+k5WNh4t1m32DC2xdn9fqss9Z9YPd/9WCm7Vf/65ew=;
 b=2zymtYGOTVIqwOqmTT1uPrw4ktQgtYc4UWdH/l78F0FqiIsCXKaLTr0LLhQagMuPW/
 p7U1E4/EOBogSziXW1nA4x4oiZPAnASQrOQmR3LP4MimCzJq5hU8hG9jMqN+C83xDmT3
 7w3HZOOFtoD05aTIaLy7Z1i5BDd+gepW74bXQMfilRQCBEl3F7QdcU/K3NKV3sLjWqU7
 ShKEeCRpuoV70UtRuO5UuS9d9cbG3P9DMZEhpXzHRMPvmj2G9q8UC9sMqDNNm7r9ahog
 B+f40k4oaXjazG/ZhgXxHIO5dQzZWdykG2SrCGhpAT3p+A5izSt/yYaVHdSHVeHRIQaC
 1vHQ==
X-Gm-Message-State: AJIora93kZ9nBZ6wfk7CGBGnrVAJB5Wdmbq7Pw8Xl5JCXkutqZxi0Uqg
 E3xLJCW1SKsx5NZcIKX1SWXUkw==
X-Google-Smtp-Source: AGRyM1tHTutF3/J1jx5hyumfSIH5Nny7tbSTVRFNGviIDr3edV8HTIveuVe3LoJ6y2mAcVox2RucNA==
X-Received: by 2002:a17:90a:4e05:b0:1ec:8de4:1dd5 with SMTP id
 n5-20020a17090a4e0500b001ec8de41dd5mr34719549pjh.242.1658188009008; 
 Mon, 18 Jul 2022 16:46:49 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com.
 [35.230.65.123]) by smtp.gmail.com with ESMTPSA id
 c13-20020aa7952d000000b0052ac5e304d0sm10157638pfp.179.2022.07.18.16.46.48
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 18 Jul 2022 16:46:48 -0700 (PDT)
Date: Mon, 18 Jul 2022 23:46:44 +0000
From: Sean Christopherson <seanjc@google.com>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v3] KVM: selftests: Fix target thread to be migrated in
 rseq_test
Message-ID: <YtXw5DKI7z9s1TA6@google.com>
References: <20220719013540.3477946-1-gshan@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220719013540.3477946-1-gshan@redhat.com>
Cc: shan.gavin@gmail.com, maz@kernel.org, linux-kernel@vger.kernel.org,
 oliver.upton@linux.dev, linux-kselftest@vger.kernel.org, pbonzini@redhat.com,
 shuah@kernel.org, kvmarm@lists.cs.columbia.edu
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Tue, Jul 19, 2022, Gavin Shan wrote:
> ---
> v3: Improved changelog (Oliver Upon)

Sorry I didn't catch v3, I saw that you waited but just didn't get to this earlier :-/

> ---
>  tools/testing/selftests/kvm/rseq_test.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/rseq_test.c b/tools/testing/selftests/kvm/rseq_test.c
> index 4158da0da2bb..c83ac7b467f8 100644
> --- a/tools/testing/selftests/kvm/rseq_test.c
> +++ b/tools/testing/selftests/kvm/rseq_test.c
> @@ -38,6 +38,7 @@ static __thread volatile struct rseq __rseq = {
>   */
>  #define NR_TASK_MIGRATIONS 100000
>  
> +static pid_t rseq_tid;
>  static pthread_t migration_thread;
>  static cpu_set_t possible_mask;
>  static int min_cpu, max_cpu;
> @@ -106,7 +107,8 @@ static void *migration_worker(void *ign)

Pass the target TID to the worker, then there's no need to use a global and no
chance of consuming rseq_tid "uninitialized".  The casting to convert gettid() to
a "void *" is annoying, but not the end of the world.

>  		 * stable, i.e. while changing affinity is in-progress.
>  		 */
>  		smp_wmb();
> -		r = sched_setaffinity(0, sizeof(allowed_mask), &allowed_mask);
> +		r = sched_setaffinity(rseq_tid, sizeof(allowed_mask),
> +				      &allowed_mask);

Eh, let this poke out, don't think it's worth wrapping here.

E.g.

---
 tools/testing/selftests/kvm/rseq_test.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/rseq_test.c b/tools/testing/selftests/kvm/rseq_test.c
index aba7be178dab..a54d4d05a058 100644
--- a/tools/testing/selftests/kvm/rseq_test.c
+++ b/tools/testing/selftests/kvm/rseq_test.c
@@ -80,8 +80,9 @@ static int next_cpu(int cpu)
 	return cpu;
 }

-static void *migration_worker(void *ign)
+static void *migration_worker(void *__rseq_tid)
 {
+	pid_t rseq_tid = (pid_t)(unsigned long)__rseq_tid;
 	cpu_set_t allowed_mask;
 	int r, i, cpu;

@@ -104,7 +105,7 @@ static void *migration_worker(void *ign)
 		 * stable, i.e. while changing affinity is in-progress.
 		 */
 		smp_wmb();
-		r = sched_setaffinity(0, sizeof(allowed_mask), &allowed_mask);
+		r = sched_setaffinity(rseq_tid, sizeof(allowed_mask), &allowed_mask);
 		TEST_ASSERT(!r, "sched_setaffinity failed, errno = %d (%s)",
 			    errno, strerror(errno));
 		smp_wmb();
@@ -227,7 +228,8 @@ int main(int argc, char *argv[])
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 	ucall_init(vm, NULL);

-	pthread_create(&migration_thread, NULL, migration_worker, 0);
+	pthread_create(&migration_thread, NULL, migration_worker,
+		       (void *)(unsigned long)gettid());

 	for (i = 0; !done; i++) {
 		vcpu_run(vcpu);

base-commit: ad6cb756bb497997032df2bda7cbdff076e4a66a
--
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
