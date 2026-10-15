Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7713B531AEB
	for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 14:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792074405; cv=none; b=QViFksYRwQEm6LG8nr9Z4dvxJTekhUpr5uhhkWKJpJtv6wxGJjPPO2d37zA3Q/mV2IKALFBwY4Ls5bg+y776vQkFlH50dlpQAtOf6QCqN/HCdAiLPTy9BpxhAZpETFoEjAPYROMT2Fbap6AQ6w9XgJQ3hmd8fDLdnTr2wkfZgfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792074405; c=relaxed/simple;
	bh=J4LmOj3stGsqQq4K4suRvHIrX2lMfgD++n0EEU7SqhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=odCWqJEHHBqsmJKseNQG6Sj5a9/Gry7NmsGqpPNO3Of/1/mwmkEytDgr4R9VE13J/qtF/a2xOxakSl4PxOaxhO6g6LyPyhGxPdedMbPtb/lY1AcAWwoc6u/gKXBf72HjDQ6h3tgeL+BEFx7nfVu30w1TyeHCqorB2xw9zCTqVQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=KXBAI+KY; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="KXBAI+KY"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 837C116F8;
	Thu, 15 Oct 2026 07:26:28 -0700 (PDT)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com [10.2.198.107])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2F8AB3F959;
	Thu, 15 Oct 2026 07:26:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792074391; bh=J4LmOj3stGsqQq4K4suRvHIrX2lMfgD++n0EEU7SqhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KXBAI+KYWyRcOxdb6aCY6btJhPNygaSka4qG4/ydw0eg3gPS7av8+4BDkCwGmkN7W
	 6tldsK4KUkq5qNPXG76d47mtDVpp4y1JytJ44C8xTcbmdrVEKFIGD5n3UAiwE/jpwp
	 zzMmgIS3iomzSQrb9mEX5kwzDBd62FLe8XE99SCU=
From: Ryan Roberts <ryan.roberts@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Alex Williamson <alex@shazbot.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	Oded Gabbay <ogabbay@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>
Cc: Ryan Roberts <ryan.roberts@arm.com>,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	devicetree@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-doc@vger.kernel.org
Subject: [RFC PATCH v2 08/15] misc/arm-cla: Manage domain contexts
Date: Thu, 15 Oct 2026 15:25:42 +0100
Message-ID: <20261015142552.4128028-9-ryan.roberts@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261015142552.4128028-1-ryan.roberts@arm.com>
References: <20261015142552.4128028-1-ryan.roberts@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A CLA domain cannot be used by multiple address spaces concurrently
because its devices share a memory translation context and may
communicate without isolation. Represent each user of a domain with a
context keyed by the mm_struct and device file description, and track
contexts in a per-domain hash table.

Add a domain scheduler that queues contexts for assignment and gives
each one a fixed time slice. Before switching, revoke the outgoing
context's mappings from all VMAs for the device file. Then save its
accelerator state and remove its MTC, before installing the incoming
context's MTC and restoring the incoming accelerator state.

Run hardware operations through CPU-bound kthread workers, since each
CLA can only be accessed from its local CPU. Coordinate the per-device
workers with a domain worker so that every CLA in the domain is switched
as a single assignment unit.

Treat a failure on any device as a failure of the whole domain. Stop
further assignments and wake all waiters when a domain becomes unusable.

Co-developed-by: Jean-Philippe Brucker <jpb@kernel.org>
Signed-off-by: Jean-Philippe Brucker <jpb@kernel.org>
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
---
 drivers/misc/arm-cla/Makefile       |   2 +
 drivers/misc/arm-cla/arm-cla.h      | 118 +++++++
 drivers/misc/arm-cla/cla-ctx.c      | 146 +++++++++
 drivers/misc/arm-cla/cla-init.c     |  62 ++++
 drivers/misc/arm-cla/cla-regs.c     |  26 +-
 drivers/misc/arm-cla/cla-sched.c    | 473 ++++++++++++++++++++++++++++
 drivers/misc/arm-cla/cla-topology.c |  23 ++
 7 files changed, 841 insertions(+), 9 deletions(-)
 create mode 100644 drivers/misc/arm-cla/cla-ctx.c
 create mode 100644 drivers/misc/arm-cla/cla-sched.c

diff --git a/drivers/misc/arm-cla/Makefile b/drivers/misc/arm-cla/Makefile
index df3ad7e4a1b4..a92c3594e5c9 100644
--- a/drivers/misc/arm-cla/Makefile
+++ b/drivers/misc/arm-cla/Makefile
@@ -2,9 +2,11 @@
 
 arm-cla-y := \
 	cla-init.o \
+	cla-ctx.o \
 	cla-mtc.o \
 	cla-ops.o \
 	cla-regs.o \
+	cla-sched.o \
 	cla-topology.o
 
 obj-$(CONFIG_ARM_CLA) += arm-cla.o
diff --git a/drivers/misc/arm-cla/arm-cla.h b/drivers/misc/arm-cla/arm-cla.h
index 40e95d3128ad..a797330956d9 100644
--- a/drivers/misc/arm-cla/arm-cla.h
+++ b/drivers/misc/arm-cla/arm-cla.h
@@ -7,8 +7,19 @@
 #ifndef _ARM_CLA_H_
 #define _ARM_CLA_H_
 
+#include <linux/atomic.h>
+#include <linux/cdev.h>
 #include <linux/device.h>
 #include <linux/io.h>
+#include <linux/kref.h>
+#include <linux/kthread.h>
+#include <linux/list.h>
+#include <linux/mm.h>
+#include <linux/mm_types.h>
+#include <linux/mutex.h>
+#include <linux/rhashtable-types.h>
+#include <linux/wait.h>
+#include <linux/workqueue.h>
 
 #include "arm-cla-regs.h"
 
@@ -17,8 +28,20 @@
 #define CLA_NUM_DATA_REGS	8
 #define CLA_SRSTATE_LEN		8
 
+/* Quantum of CLA assignment */
+#define CLA_SLICE_MS		100
+
 struct cla_domain;
 
+struct cla_call_on_cpu {
+	int ret;
+	struct {
+		struct cla_ctx *prev_ctx;
+		struct cla_ctx *next_ctx;
+	} sched;
+	struct kthread_work switch_ctx;
+};
+
 /**
  * struct cla_dev - CLA device
  *
@@ -35,6 +58,8 @@ struct cla_domain;
  * Mutable, protected by CPU hotplug locking:
  * @discovered:		Discovered state is cached.
  * @broken:		Hardware failure.
+ * @worker:		CPU-bound worker to communicate with CLA.
+ * @call:		Scheduling work.
  */
 struct cla_dev {
 	unsigned int cpu;
@@ -48,22 +73,45 @@ struct cla_dev {
 
 	bool discovered;
 	bool broken;
+	struct kthread_worker *worker;
+	struct cla_call_on_cpu call;
 };
 
 /**
  * struct cla_domain - Collection of cla_dev
  *
+ * The whole domain is assigned to a single cla_ctx at a time.
+ *
  * Immutable state:
  * @id:			Consecutive userspace domain identifier.
  * @pg_offset:		Mmap offset of the first device.
  * @nr_devs:		Number of devices in the domain.
  * @devs:		Devices.
+ *
+ * Mutable, only accessed under @lock:
+ * @lock:		Protects the following members.
+ * @ctxs:		All live contexts, keyed on cla_ctx_key.
+ * @queued_ctxs:	Queue of contexts waiting for assignment.
+ * @worker:		Kthread worker to coordinate reassignment.
+ * @reassign:		Delayed work that switches contexts with time slicing.
+ *
+ * Mutable, some reads outside the lock:
+ * @broken:		Hardware failure in any device in the domain.
+ * @assigned_ctx:	Context to which domain is currently assigned.
  */
 struct cla_domain {
 	unsigned int id;
 	unsigned long pg_offset;
 	unsigned int nr_devs;
 	struct cla_dev **devs;
+
+	struct mutex lock;
+	bool broken;
+	struct rhashtable ctxs;
+	struct list_head queued_ctxs;
+	struct cla_ctx *assigned_ctx;
+	struct kthread_worker *worker;
+	struct kthread_delayed_work reassign;
 };
 
 /**
@@ -93,10 +141,48 @@ struct cla_ctx_key {
 	struct file *file;
 };
 
+#define CLA_CTX_KEY_PL0(_mm, _file)		\
+	{					\
+		.mm = (_mm),			\
+		.file = (_file),		\
+	}
+
+/**
+ * struct cla_ctx - Domain context
+ *
+ * Immutable state:
+ * @domain:		The domain of this context.
+ * @key:		Key in cla_domain::ctxs hashtable.
+ * @node:		Node in cla_domain::ctxs hashtable.
+ *
+ * Mutable, reference counted:
+ * @refcnt:		All references to this context. Context is freed
+ *			when this drops to zero.
+ *
+ * Mutable, protected by domain::lock:
+ * @queue_node:		Node in cla_domain::queued_ctxs.
+ * @waitq:		Faulting threads sleep until assignment.
+ *
+ * Mutable, protected by domain::lock, some reads outside the lock:
+ * @users:		Users accessing this context. Context is killed when
+ *			this drops to zero.
+ *
+ * Mutable, written by domain reassignment, device work, and CPU hotplug:
+ * @regs:		State for each device in domain.
+ * @asid:		Pinned ASID of live context.
+ */
 struct cla_ctx {
+	struct kref refcnt;
+	struct rhash_head node;
+
+	struct cla_domain *domain;
 	struct cla_ctx_key key;
+
+	refcount_t users;
+	struct list_head queue_node;
 	void **regs;
 	unsigned int asid;
+	wait_queue_head_t waitq;
 };
 
 extern struct xarray cla_domains;
@@ -142,7 +228,39 @@ static inline void cla_reg_write(struct cla_dev *dev, off_t reg, u64 val)
 
 struct cla_domain *cla_dev_domain_get(struct cla_dev *dev);
 int cla_domains_finalise(void);
+void cla_domains_sched_exit(void);
 void cla_domains_free(void);
+int cla_domain_sched_init(struct cla_domain *domain);
+void cla_domain_sched_exit(struct cla_domain *domain);
+void cla_domain_set_broken(struct cla_domain *domain);
+struct cla_ctx *cla_domain_lookup_ctx(struct cla_domain *domain,
+				      struct cla_ctx_key *key);
+int cla_domain_insert_ctx(struct cla_domain *domain, struct cla_ctx *ctx);
+void cla_domain_remove_ctx(struct cla_domain *domain, struct cla_ctx *ctx);
+void cla_domain_schedule_reassignment(struct cla_domain *domain);
+struct cla_ctx *cla_ctx_create(struct cla_domain *domain,
+			       struct cla_ctx_key *key);
+void cla_ctx_destroy(struct cla_domain *domain, struct cla_ctx_key *key);
+void cla_ctx_free(struct kref *ref);
+
+static inline void cla_ctx_get(struct cla_ctx *ctx)
+{
+	kref_get(&ctx->refcnt);
+}
+
+static inline void cla_ctx_put(struct cla_ctx *ctx)
+{
+	kref_put(&ctx->refcnt, cla_ctx_free);
+}
+
+static inline bool cla_ctx_is_dying(struct cla_ctx *ctx)
+{
+	return refcount_read(&ctx->users) == 0;
+}
+
+void cla_dev_switch_ctx_work(struct kthread_work *work);
+int cla_dev_switch_ctx(struct cla_dev *dev, struct cla_ctx *prev_ctx,
+		       struct cla_ctx *next_ctx);
 
 int cla_op_wait_lresp(struct cla_dev *dev, u64 *lresp);
 int cla_op_reset(struct cla_dev *dev, unsigned int accid);
diff --git a/drivers/misc/arm-cla/cla-ctx.c b/drivers/misc/arm-cla/cla-ctx.c
new file mode 100644
index 000000000000..6a9c95769724
--- /dev/null
+++ b/drivers/misc/arm-cla/cla-ctx.c
@@ -0,0 +1,146 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/err.h>
+#include <linux/file.h>
+#include <linux/gfp.h>
+#include <linux/sched/mm.h>
+#include <linux/slab.h>
+
+#include "arm-cla.h"
+
+/**
+ * cla_ctx_create - Create a context or increase its user count
+ * @domain: CLA domain
+ * @key: Context identifier
+ *
+ * Reuse an existing context for the same @key, or allocate and insert a new
+ * context into @domain. The context user count is incremented before returning.
+ *
+ * Return: the context on success, or an error pointer on failure
+ */
+struct cla_ctx *cla_ctx_create(struct cla_domain *domain,
+			       struct cla_ctx_key *key)
+{
+	struct cla_ctx *ctx;
+	int ret = -ENOMEM;
+
+	mutex_lock(&domain->lock);
+	ctx = cla_domain_lookup_ctx(domain, key);
+	if (ctx) {
+		refcount_inc(&ctx->users);
+		mutex_unlock(&domain->lock);
+		return ctx;
+	}
+
+	if (domain->broken) {
+		ret = -EIO;
+		goto err_unlock;
+	}
+
+	ctx = kzalloc_obj(*ctx, GFP_KERNEL_ACCOUNT);
+	if (!ctx)
+		goto err_unlock;
+
+	kref_init(&ctx->refcnt);
+	refcount_set(&ctx->users, 1);
+	ctx->domain = domain;
+	ctx->key = *key;
+	INIT_LIST_HEAD(&ctx->queue_node);
+	init_waitqueue_head(&ctx->waitq);
+
+	mmgrab(key->mm);
+	get_file(key->file);
+
+	/*
+	 * Test if the mm or kvm is compatible. If cla_mtc_get_ctx() fails
+	 * during context switch, it breaks the domain.
+	 */
+	ret = cla_mtc_get_ctx(ctx);
+	if (ret)
+		goto err_free;
+	cla_mtc_put_ctx(ctx);
+
+	ret = cla_ctx_alloc_regs(domain, ctx);
+	if (ret)
+		goto err_free;
+
+	ret = cla_domain_insert_ctx(domain, ctx);
+	if (ret)
+		goto err_free_regs;
+	mutex_unlock(&domain->lock);
+
+	return ctx;
+
+err_free_regs:
+	cla_ctx_free_regs(domain, ctx);
+err_free:
+	mmdrop(key->mm);
+	fput(key->file);
+	kfree(ctx);
+err_unlock:
+	mutex_unlock(&domain->lock);
+	return ERR_PTR(ret);
+}
+
+/**
+ * cla_ctx_destroy - Drop a context user
+ * @domain: CLA domain
+ * @key: Context identifier
+ *
+ * When the final user is removed, wake waiters, remove the context from
+ * @domain, schedule deassignment if needed, and drop the user's reference.
+ */
+void cla_ctx_destroy(struct cla_domain *domain, struct cla_ctx_key *key)
+{
+	struct cla_ctx *ctx;
+
+	mutex_lock(&domain->lock);
+	ctx = cla_domain_lookup_ctx(domain, key);
+	WARN_ON(!ctx);
+
+	if (!refcount_dec_and_test(&ctx->users)) {
+		mutex_unlock(&domain->lock);
+		return;
+	}
+
+	/* Notify waiters that their context is dying. */
+	wake_up_all(&ctx->waitq);
+	cla_domain_remove_ctx(domain, ctx);
+	list_del_init(&ctx->queue_node);
+
+	/*
+	 * Since we're holding the mmap_lock for writing, and reassignment work
+	 * may be waiting to grab it for reading, we cannot wait for
+	 * reassignment here. The context holds a reference to mm_count, so the
+	 * mm_struct or pgd are not going away until cla_ctx_free().
+	 * If the mm is exiting, the accelerators will now access memory through
+	 * an empty pgd and fault silently.
+	 *
+	 * Assignment holds a reference until deassignment completes. If this
+	 * context is being assigned, reassignment will notice that it is dying
+	 * and schedule its deassignment once it re-takes the domain lock.
+	 */
+	if (domain->assigned_ctx == ctx)
+		cla_domain_schedule_reassignment(domain);
+	mutex_unlock(&domain->lock);
+
+	/* Release initial reference from cla_ctx_create(). */
+	cla_ctx_put(ctx);
+}
+
+/**
+ * cla_ctx_free - Free a CLA domain context
+ * @ref: context reference counter
+ *
+ * Release resources held by a dying context after final reference is dropped.
+ */
+void cla_ctx_free(struct kref *ref)
+{
+	struct cla_ctx *ctx = container_of(ref, struct cla_ctx, refcnt);
+
+	WARN_ON(!cla_ctx_is_dying(ctx));
+	mmdrop(ctx->key.mm);
+	fput(ctx->key.file);
+	cla_ctx_free_regs(ctx->domain, ctx);
+	kfree(ctx);
+}
diff --git a/drivers/misc/arm-cla/cla-init.c b/drivers/misc/arm-cla/cla-init.c
index 58f37787a59c..e1694f84e05d 100644
--- a/drivers/misc/arm-cla/cla-init.c
+++ b/drivers/misc/arm-cla/cla-init.c
@@ -186,7 +186,10 @@ static void cla_dev_reinit(struct cla_dev *dev)
 
 	if (WARN_ON(cla_op_reset_all(dev)) ||
 	    WARN_ON(cla_mtc_clear(dev))) {
+		mutex_lock(&dev->domain->lock);
 		dev->broken = true;
+		cla_domain_set_broken(dev->domain);
+		mutex_unlock(&dev->domain->lock);
 		return;
 	}
 
@@ -198,6 +201,37 @@ static void cla_dev_reinit(struct cla_dev *dev)
 	cla_reg_write(dev, CLA_REG_LRESP, 0);
 }
 
+static int cla_dev_worker_init(struct cla_dev *dev, int cpu)
+{
+	struct kthread_worker *worker;
+
+	worker = kthread_run_worker_on_cpu(cpu, 0, "cla-dev-worker/%u");
+	if (IS_ERR(worker))
+		return PTR_ERR(worker);
+
+	WARN_ON(dev->worker);
+	dev->worker = worker;
+
+	return 0;
+}
+
+static void cla_dev_worker_destroy(struct cla_dev *dev)
+{
+	if (!dev->worker)
+		return;
+
+	/*
+	 * CPU offlining excludes submitters holding cpus_read_lock(). During
+	 * module removal, submitters are stopped before removing the hotplug
+	 * callbacks, which only takes the hotplug read lock.
+	 */
+	kthread_destroy_worker(dev->worker);
+	dev->worker = NULL;
+
+	/* Clear work->worker before any later flush or reuse with a new worker. */
+	kthread_init_work(&dev->call.switch_ctx, cla_dev_switch_ctx_work);
+}
+
 static int cla_dev_setup(unsigned int cpu)
 {
 	int i;
@@ -252,8 +286,23 @@ static int cla_dev_setup(unsigned int cpu)
 			 dev->accelerators);
 	}
 
+	ret = cla_dev_worker_init(dev, cpu);
+	if (ret)
+		goto err;
+
+	/* Restore context if domain has an assigned context. */
+	mutex_lock(&dev->domain->lock);
+	ret = cla_dev_switch_ctx(dev, NULL, dev->domain->assigned_ctx);
+	if (ret)
+		cla_domain_set_broken(dev->domain);
+	mutex_unlock(&dev->domain->lock);
+	if (ret)
+		goto err_worker;
+
 	dev->discovered = true;
 	return 0;
+err_worker:
+	cla_dev_worker_destroy(dev);
 err:
 	cla_dev_reinit(dev);
 	return ret;
@@ -262,6 +311,7 @@ static int cla_dev_setup(unsigned int cpu)
 static int cla_dev_teardown(unsigned int cpu)
 {
 	struct cla_dev *dev;
+	int ret;
 
 	/*
 	 * Careful what we return here, the teardown path isn't really allowed
@@ -271,6 +321,15 @@ static int cla_dev_teardown(unsigned int cpu)
 	if (!dev)
 		return 0;
 
+	cla_dev_worker_destroy(dev);
+
+	/* Save context if domain has an assigned context. */
+	mutex_lock(&dev->domain->lock);
+	ret = cla_dev_switch_ctx(dev, dev->domain->assigned_ctx, NULL);
+	if (ret)
+		cla_domain_set_broken(dev->domain);
+	mutex_unlock(&dev->domain->lock);
+
 	cla_dev_reinit(dev);
 
 	return 0;
@@ -314,6 +373,7 @@ static struct cla_dev *cla_dev_alloc(struct device *parent, int cpu,
 	dev->cpu = cpu;
 	dev->dev = parent;
 
+	kthread_init_work(&dev->call.switch_ctx, cla_dev_switch_ctx_work);
 
 	/* Attempt to find device domain, or allocate a new one */
 	dev->domain = cla_dev_domain_get(dev);
@@ -441,6 +501,7 @@ static int __init cla_module_init(void)
 	return 0;
 
 err_hardware:
+	cla_domains_sched_exit();
 	if (cla_cpuhp_state >= 0)
 		cpuhp_remove_state(cla_cpuhp_state);
 	cla_domains_free();
@@ -451,6 +512,7 @@ static int __init cla_module_init(void)
 
 static void __exit cla_module_exit(void)
 {
+	cla_domains_sched_exit();
 	cpuhp_remove_state(cla_cpuhp_state);
 	cla_domains_free();
 	platform_driver_unregister(&cla_driver);
diff --git a/drivers/misc/arm-cla/cla-regs.c b/drivers/misc/arm-cla/cla-regs.c
index 2452a7601990..d8ed74230e16 100644
--- a/drivers/misc/arm-cla/cla-regs.c
+++ b/drivers/misc/arm-cla/cla-regs.c
@@ -128,16 +128,23 @@ static int cla_regs_uninstall_pl0(struct cla_dev *dev, struct cla_ctx *ctx,
 	if (ret)
 		return ret;
 
-	for (i = 0; i < CLA_NUM_DATA_REGS; i++)
-		regs->data[i] = cla_reg_read(dev, CLA_REG_DATA(i));
+	/*
+	 * No need to save a dying context. Note that we're not holding the
+	 * domain lock during this check and the context might be about to die,
+	 * but it's only an optimisation.
+	 */
+	if (!cla_ctx_is_dying(ctx)) {
+		for (i = 0; i < CLA_NUM_DATA_REGS; i++)
+			regs->data[i] = cla_reg_read(dev, CLA_REG_DATA(i));
 
-	cla_for_each_accid(dev, accid) {
-		ret = cla_regs_save_accel(dev, accid, regs, &regstate_off);
-		if (ret)
-			return ret;
-	}
+		cla_for_each_accid(dev, accid) {
+			ret = cla_regs_save_accel(dev, accid, regs, &regstate_off);
+			if (ret)
+				return ret;
+		}
 
-	regs->accel_valid = true;
+		regs->accel_valid = true;
+	}
 
 	/*
 	 * "If the accelerator is non idle when ENTERSR is launched, then a
@@ -218,7 +225,8 @@ int cla_regs_install(struct cla_dev *dev, struct cla_ctx *ctx,
  *
  * Uninstall a user context, and restore the kernel context if necessary.
  *
- * PL0 context: Save the DATA and LRESP registers and accelerator state.
+ * PL0 context: Save the DATA registers and accelerator state unless
+ * cla_ctx_is_dying() is true, since a dying context will not be restored.
  *
  * When this completes, all accelerators are idle. If this fails, some
  * accelerators may still be running.
diff --git a/drivers/misc/arm-cla/cla-sched.c b/drivers/misc/arm-cla/cla-sched.c
new file mode 100644
index 000000000000..6b5b782ac33e
--- /dev/null
+++ b/drivers/misc/arm-cla/cla-sched.c
@@ -0,0 +1,473 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Arm CLA driver - domain scheduling
+ *
+ * Copyright 2026 Arm Limited.
+ */
+
+#include <linux/cpuhplock.h>
+#include <linux/rhashtable.h>
+
+#include "arm-cla.h"
+
+static struct cla_ctx invalid_ctx;
+
+static const struct rhashtable_params ctxs_rht_params = {
+	.head_offset = offsetof(struct cla_ctx, node),
+	.key_offset = offsetof(struct cla_ctx, key),
+	.key_len = sizeof(((struct cla_ctx *)0)->key),
+	.automatic_shrinking = true,
+};
+
+static int __cla_domain_switch_ctx(struct cla_domain *domain,
+				   struct cla_ctx *prev_ctx,
+				   struct cla_ctx *next_ctx)
+{
+	int ret = 0;
+	unsigned int i;
+	struct cla_dev *dev;
+	struct cla_call_on_cpu *call;
+
+	lockdep_assert_cpus_held();
+
+	if (!prev_ctx && !next_ctx)
+		return 0;
+
+	for (i = 0; i < domain->nr_devs; i++) {
+		dev = domain->devs[i];
+		call = &dev->call;
+
+		call->sched.prev_ctx = prev_ctx;
+		call->sched.next_ctx = next_ctx;
+		call->ret = 0;
+
+		if (dev->broken)
+			ret = -EIO;
+		else if (dev->worker)
+			kthread_queue_work(dev->worker, &call->switch_ctx);
+	}
+
+	for (i = 0; i < domain->nr_devs; i++) {
+		dev = domain->devs[i];
+		call = &dev->call;
+
+		kthread_flush_work(&call->switch_ctx);
+
+		/*
+		 * kthread worker and kthread_flush_work() both take the worker
+		 * lock to respectively write and read the current_work,
+		 * providing the desired memory ordering for ret.
+		 */
+		if (call->ret)
+			ret = call->ret;
+	}
+
+	return ret;
+}
+
+static int cla_domain_switch_ctx(struct cla_domain *domain,
+				 struct cla_ctx *prev_ctx,
+				 struct cla_ctx *next_ctx,
+				 struct cla_ctx **assigned_ctx)
+{
+	int ret;
+
+	/* Remove prev_ctx from all devices in the domain */
+	*assigned_ctx = prev_ctx;
+	ret = __cla_domain_switch_ctx(domain, prev_ctx, NULL);
+	if (ret)
+		return ret;
+
+	*assigned_ctx = NULL;
+	if (prev_ctx)
+		cla_mtc_put_ctx(prev_ctx);
+	if (next_ctx) {
+		ret = cla_mtc_get_ctx(next_ctx);
+		if (ret)
+			return ret;
+	}
+
+	/* Install next_ctx into all devices in the domain */
+	*assigned_ctx = next_ctx;
+	return __cla_domain_switch_ctx(domain, NULL, next_ctx);
+}
+
+/*
+ * Run on the cla's local CPU, either in its worker or a CPU hotplug callback.
+ * Work submitters hold cpus_read_lock() until completion, excluding hotplug
+ * callbacks and keeping the worker bound. Hotplug callbacks hold domain->lock
+ * to protect the assigned context. Other devices may switch concurrently.
+ * On failure, mark the device broken; the caller handles domain failure.
+ */
+int cla_dev_switch_ctx(struct cla_dev *dev, struct cla_ctx *prev_ctx,
+		       struct cla_ctx *next_ctx)
+{
+	unsigned int ctx_id = dev->pg_offset - dev->domain->pg_offset;
+	int ret;
+
+	if (WARN_ON(smp_processor_id() != dev->cpu)) {
+		ret = -EINVAL;
+		goto err;
+	}
+
+	/* Save state for outgoing ctx. */
+	if (prev_ctx) {
+		ret = cla_regs_uninstall(dev, prev_ctx, ctx_id);
+		if (ret) {
+			cla_err(dev, "failed to remove regs: %d\n", ret);
+			goto err;
+		}
+
+		ret = cla_mtc_uninstall(dev, prev_ctx);
+		if (ret) {
+			cla_err(dev, "failed to remove mm: %d\n", ret);
+			goto err;
+		}
+	}
+
+	/* Restore state for incoming ctx. */
+	if (next_ctx) {
+		ret = cla_mtc_install(dev, next_ctx);
+		if (ret) {
+			cla_err(dev, "failed to setup mm: %d\n", ret);
+			goto err;
+		}
+
+		ret = cla_regs_install(dev, next_ctx, ctx_id);
+		if (ret) {
+			cla_err(dev, "failed to setup regs: %d\n", ret);
+			goto err;
+		}
+	}
+
+	return 0;
+err:
+	dev->broken = true;
+	return ret;
+}
+
+void cla_dev_switch_ctx_work(struct kthread_work *work)
+{
+	struct cla_call_on_cpu *call =
+		container_of(work, struct cla_call_on_cpu, switch_ctx);
+	struct cla_dev *dev = container_of(call, struct cla_dev, call);
+
+	call->ret = cla_dev_switch_ctx(dev, call->sched.prev_ctx,
+				       call->sched.next_ctx);
+}
+
+static inline struct cla_ctx *cla_domain_get_next_ctx(struct cla_domain *domain)
+{
+	return list_first_entry_or_null(&domain->queued_ctxs, struct cla_ctx,
+					queue_node);
+}
+
+static inline struct cla_ctx *cla_domain_get_prev_ctx(struct cla_domain *domain,
+						      struct cla_ctx *next_ctx)
+{
+	if (domain->assigned_ctx && (next_ctx || cla_ctx_is_dying(domain->assigned_ctx)))
+		return domain->assigned_ctx;
+	return NULL;
+}
+
+static void cla_vma_zap_domain(struct vm_area_struct *vma, struct cla_domain *domain)
+{
+	unsigned long vma_start = vma->vm_pgoff;
+	unsigned long vma_end = vma_start + vma_pages(vma);
+	unsigned long domain_start = domain->pg_offset;
+	unsigned long domain_end = domain_start + domain->nr_devs;
+	unsigned long start = max(vma_start, domain_start);
+	unsigned long end = min(vma_end, domain_end);
+	unsigned long addr;
+	unsigned long size;
+
+	if (start >= end)
+		return;
+
+	addr = vma->vm_start + ((start - vma_start) << PAGE_SHIFT);
+	size = (end - start) << PAGE_SHIFT;
+	zap_special_vma_range(vma, addr, size);
+}
+
+static void cla_domain_zap(struct cla_domain *domain, struct cla_ctx *ctx)
+{
+	struct vm_area_struct *vma;
+	struct vma_iterator vmi;
+
+	/*
+	 * If the context is dying it has already been unmapped, no need to zap
+	 * it here.
+	 */
+	if (!ctx || cla_ctx_is_dying(ctx))
+		return;
+
+	if (!mmget_not_zero(ctx->key.mm))
+		return;
+
+	/*
+	 * Iterate over vmas in prev_ctx's mm, looking for vmas that map
+	 * prev_ctx's file. Zap any portions of those vmas that map the domain.
+	 */
+	mmap_read_lock(ctx->key.mm);
+	vma_iter_init(&vmi, ctx->key.mm, 0);
+	for_each_vma(vmi, vma) {
+		if (vma->vm_file != ctx->key.file)
+			continue;
+
+		cla_vma_zap_domain(vma, domain);
+	}
+	mmap_read_unlock(ctx->key.mm);
+	mmput(ctx->key.mm);
+}
+
+static void cla_domain_reassign(struct kthread_work *work)
+{
+	struct cla_ctx *assigned_ctx = NULL;
+	struct cla_ctx *prev_ctx = NULL;
+	struct cla_ctx *next_ctx = NULL;
+	struct cla_domain *domain;
+	int ret;
+
+	domain = container_of(work, struct cla_domain, reassign.work);
+
+	/*
+	 * Exclude cpuhp until assigned_ctx reflects the hardware again. cpuhp
+	 * callbacks use it to save/restore the local device and must not see
+	 * invalid_ctx. Take before domain->lock, also used by cpuhp callbacks.
+	 */
+	cpus_read_lock();
+	mutex_lock(&domain->lock);
+	if (domain->broken)
+		goto out_unlock;
+
+	/* Figure out prev_ctx and next_ctx. NULL indicates don't [un]assign. */
+	next_ctx = cla_domain_get_next_ctx(domain);
+	prev_ctx = cla_domain_get_prev_ctx(domain, next_ctx);
+
+	if (!prev_ctx && !next_ctx)
+		goto out_unlock;
+
+	/* prev_ctx already holds its assignment reference. */
+	if (next_ctx)
+		cla_ctx_get(next_ctx);
+
+	/*
+	 * We need to grab mmap_lock, but can't do so while holding the domain
+	 * lock (since cla_vma_fault() grabs the domain lock while holding
+	 * mmap_lock). The queue may change and contexts may be killed by
+	 * cla_ctx_destroy() while the lock is dropped.
+	 *
+	 * No user is allowed to access CLA while we are reassigning. Disable
+	 * assigned_ctx before zapping so cla_vma_fault() won't re-map the
+	 * domain during reassignment. The sentinel also defers broken-domain
+	 * cleanup until we know which context hardware may still access.
+	 */
+	WRITE_ONCE(domain->assigned_ctx, &invalid_ctx);
+	mutex_unlock(&domain->lock);
+
+	/* Prevent prev_ctx from accessing any device in the domain. */
+	cla_domain_zap(domain, prev_ctx);
+
+	/* cpus_read_lock() ensures workers remain cpu-bound and alive. */
+	ret = cla_domain_switch_ctx(domain, prev_ctx, next_ctx, &assigned_ctx);
+
+	mutex_lock(&domain->lock);
+	WRITE_ONCE(domain->assigned_ctx, assigned_ctx);
+
+	/* Also handle failure reported by another thread during the switch. */
+	if (ret || domain->broken) {
+		cla_domain_set_broken(domain);
+		goto out_unlock;
+	}
+
+	/*
+	 * Remove next_ctx from the queue and wake up all waiters so that the
+	 * fault handler can map the domain into the newly assigned process.
+	 * assigned_ctx must have been updated prior to waking the waiters.
+	 *
+	 * If next_ctx was killed while we were assigning it, schedule another
+	 * reassignment to deassign it.
+	 */
+	if (next_ctx) {
+		if (cla_ctx_is_dying(next_ctx)) {
+			cla_domain_schedule_reassignment(domain);
+			goto out_unlock;
+		}
+		list_del_init(&next_ctx->queue_node);
+		wake_up_all(&next_ctx->waitq);
+	}
+
+	/* If there are more queued ctxs, schedule the next reassignment. */
+	if (!list_empty(&domain->queued_ctxs))
+		cla_domain_schedule_reassignment(domain);
+
+out_unlock:
+	mutex_unlock(&domain->lock);
+	cpus_read_unlock();
+
+	/* Deliberately put references outside of the locks. */
+	if (next_ctx && next_ctx != assigned_ctx)
+		cla_ctx_put(next_ctx);
+	if (prev_ctx && prev_ctx != assigned_ctx)
+		cla_ctx_put(prev_ctx);
+}
+
+/**
+ * cla_domain_sched_init - Initialize scheduling for a CLA domain
+ * @domain: CLA domain
+ *
+ * Initialize domain context table, scheduling queues, worker, and work items.
+ *
+ * Return: 0 on success, or an error
+ */
+int cla_domain_sched_init(struct cla_domain *domain)
+{
+	int ret;
+
+	INIT_LIST_HEAD(&domain->queued_ctxs);
+	WRITE_ONCE(domain->assigned_ctx, NULL);
+
+	ret = rhashtable_init(&domain->ctxs, &ctxs_rht_params);
+	if (ret)
+		return ret;
+
+	domain->worker = kthread_run_worker(0, "cla-domain-worker");
+	if (IS_ERR(domain->worker)) {
+		rhashtable_destroy(&domain->ctxs);
+		return PTR_ERR(domain->worker);
+	}
+	kthread_init_delayed_work(&domain->reassign, cla_domain_reassign);
+
+	return 0;
+}
+
+/**
+ * cla_domain_sched_exit - Tear down scheduling for a CLA domain
+ * @domain: CLA domain
+ *
+ * Drain final deassignment, destroy the domain worker, and destroy the context
+ * table. All context users must have exited before calling this.
+ */
+void cla_domain_sched_exit(struct cla_domain *domain)
+{
+	/*
+	 * Wait for any in-flight assignment and prevent it from requeuing
+	 * itself. Otherwise, it could move the final reassignment past the
+	 * flush barrier, leaving an assignment reference behind.
+	 */
+	kthread_cancel_delayed_work_sync(&domain->reassign);
+	WARN_ON(!list_empty(&domain->queued_ctxs));
+
+	/*
+	 * All context users have exited, so this run can only deassign the
+	 * remaining context and release its assignment reference. It cannot
+	 * requeue itself, so destroying the worker also drains this final run.
+	 */
+	kthread_mod_delayed_work(domain->worker, &domain->reassign, 0);
+	kthread_destroy_worker(domain->worker);
+	WARN_ON(READ_ONCE(domain->assigned_ctx));
+
+	rhashtable_destroy(&domain->ctxs);
+}
+
+/**
+ * cla_domain_set_broken - Mark a CLA domain as broken
+ * @domain: CLA domain
+ *
+ * Prevent further assignment and wake contexts waiting for assignment. Release
+ * the assignment reference while retaining resources that failed hardware may
+ * still access. The caller must hold the domain lock.
+ */
+void cla_domain_set_broken(struct cla_domain *domain)
+{
+	struct cla_ctx *ctx;
+
+	lockdep_assert_held(&domain->lock);
+	WRITE_ONCE(domain->broken, true);
+
+	/* Notify any waiter that their context isn't getting reassigned. */
+	list_for_each_entry(ctx, &domain->queued_ctxs, queue_node)
+		wake_up_all(&ctx->waitq);
+
+	/*
+	 * During a switch, assigned_ctx is invalid_ctx. Ignore for now; we will
+	 * be called again at the end of the switch once the real context is
+	 * reinstalled in assigned_ctx.
+	 */
+	ctx = domain->assigned_ctx;
+	if (ctx && ctx != &invalid_ctx) {
+		WRITE_ONCE(domain->assigned_ctx, NULL);
+		cla_mtc_leak_ctx(ctx);
+		cla_ctx_put(ctx);
+	}
+}
+
+/**
+ * cla_domain_lookup_ctx - Look up a context in a CLA domain
+ * @domain: CLA domain
+ * @key: Context identifier
+ *
+ * The caller must hold the domain lock.
+ *
+ * Return: the matching context, or %NULL if no context was found
+ */
+struct cla_ctx *cla_domain_lookup_ctx(struct cla_domain *domain,
+				      struct cla_ctx_key *key)
+{
+	lockdep_assert_held(&domain->lock);
+	return rhashtable_lookup_fast(&domain->ctxs, key, ctxs_rht_params);
+}
+
+/**
+ * cla_domain_insert_ctx - Insert a context into a CLA domain
+ * @domain: CLA domain
+ * @ctx: context to insert
+ *
+ * The caller must hold the domain lock.
+ *
+ * Return: 0 on success, or an error
+ */
+int cla_domain_insert_ctx(struct cla_domain *domain, struct cla_ctx *ctx)
+{
+	lockdep_assert_held(&domain->lock);
+	return rhashtable_insert_fast(&domain->ctxs, &ctx->node, ctxs_rht_params);
+}
+
+/**
+ * cla_domain_remove_ctx - Remove a context from a CLA domain
+ * @domain: CLA domain
+ * @ctx: context to remove
+ *
+ * The caller must hold the domain lock.
+ */
+void cla_domain_remove_ctx(struct cla_domain *domain, struct cla_ctx *ctx)
+{
+	lockdep_assert_held(&domain->lock);
+	rhashtable_remove_fast(&domain->ctxs, &ctx->node, ctxs_rht_params);
+}
+
+/**
+ * cla_domain_schedule_reassignment - Schedule domain reassignment
+ * @domain: CLA domain
+ *
+ * The caller must hold the domain lock. If a live context is currently
+ * assigned, schedule with a delay (CLA_SLICE_MS), otherwise reassign
+ * immediately. Do nothing if the domain is broken or a switch is in progress;
+ * the running switch handles new requests before returning. If reassignment is
+ * already scheduled, the delay is modified.
+ */
+void cla_domain_schedule_reassignment(struct cla_domain *domain)
+{
+	struct cla_ctx *ctx = domain->assigned_ctx;
+	unsigned long delay_jfs = 0;
+
+	lockdep_assert_held(&domain->lock);
+
+	if (domain->broken || ctx == &invalid_ctx)
+		return;
+
+	if (ctx && !cla_ctx_is_dying(ctx))
+		delay_jfs = msecs_to_jiffies(CLA_SLICE_MS);
+
+	kthread_mod_delayed_work(domain->worker, &domain->reassign, delay_jfs);
+}
diff --git a/drivers/misc/arm-cla/cla-topology.c b/drivers/misc/arm-cla/cla-topology.c
index 5137a0e041e5..ed7acec70019 100644
--- a/drivers/misc/arm-cla/cla-topology.c
+++ b/drivers/misc/arm-cla/cla-topology.c
@@ -37,6 +37,8 @@ static struct cla_domain *cla_domain_alloc(struct cla_dev *dev, unsigned int fwi
 	if (!domain)
 		return ERR_PTR(-ENOMEM);
 
+	mutex_init(&domain->lock);
+
 	ret = xa_insert(&cla_domains, fwid, domain, GFP_KERNEL);
 	if (ret < 0)
 		goto err_free_domain;
@@ -49,8 +51,14 @@ static struct cla_domain *cla_domain_alloc(struct cla_dev *dev, unsigned int fwi
 	}
 	domain->devs[0] = dev;
 
+	ret = cla_domain_sched_init(domain);
+	if (ret)
+		goto err_free_devs;
+
 	return domain;
 
+err_free_devs:
+	kfree(domain->devs);
 err_free_id:
 	xa_erase(&cla_domains, fwid);
 err_free_domain:
@@ -149,6 +157,21 @@ int __init cla_domains_finalise(void)
 	return ret;
 }
 
+/**
+ * cla_domains_sched_exit - Drain and stop all domain schedulers
+ *
+ * All context users must have exited. Keep domains and lookup tables alive for
+ * CPU hotplug callbacks until those callbacks have been removed.
+ */
+void cla_domains_sched_exit(void)
+{
+	unsigned long fwid;
+	struct cla_domain *domain;
+
+	xa_for_each(&cla_domains, fwid, domain)
+		cla_domain_sched_exit(domain);
+}
+
 /**
  * cla_domains_free - free CLA domains and lookup tables
  *
-- 
2.43.0

