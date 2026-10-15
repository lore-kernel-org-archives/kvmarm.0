Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AABC2550DAA
	for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 14:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792074421; cv=none; b=njM4WAVCwWlAUT37QtptSG7TU/wFuXcnMgYE2SxvsdX7PPjdQcE5hygtMTdEHi1vcWdg40SubC4ffsdsmeKxIHOFZYHsWS2I7KuTnFR3x9/pmlfX8prObdufYHfu8ajsxmzPI0fgk539cXg4AtcU2dOoRbCpiZnntXzGDJeqFN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792074421; c=relaxed/simple;
	bh=DNQETDEyak8naSY4EIpo/+mHp8XBiRhp+IR8g1J6GgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bOqNZnWyGnJdTpLlOADfcAjqG2hwQS82PqRB+NL0vBBilUU6Vg9Q03S44sFZ5Qwc7KfFyVlX1GL90ZtpkNudEd3bnoJdYdfDLm1ZYNiwZlyC/1GzAYXxZamd99C5fzl/3hHlYEJlb6ooSHJVvt3Z1/r48Jtk4r+bD29X6gatWdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=WSqW9q7X; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="WSqW9q7X"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E2CC11516;
	Thu, 15 Oct 2026 07:26:48 -0700 (PDT)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com [10.2.198.107])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5CE483F871;
	Thu, 15 Oct 2026 07:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792074412; bh=DNQETDEyak8naSY4EIpo/+mHp8XBiRhp+IR8g1J6GgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WSqW9q7XxyuwSmz+6ydn2qmvCylqqdgvQfEHsW3ZI+CVk3toxpkOv3457nY01jAmL
	 oWUcu0zVjHtRyNGSfcRP8POyzvzunYIOcPRzXWxewluJvrIlTeKE6qgG26Zlih/5MS
	 N5PAD9oOQ+iEmQkBbG+Lt+WGtdQFCc3+qpopbsKY=
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
Subject: [RFC PATCH v2 14/15] misc/arm-cla: Support exclusive context assignment
Date: Thu, 15 Oct 2026 15:25:48 +0100
Message-ID: <20261015142552.4128028-15-ryan.roberts@arm.com>
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

From: Jean-Philippe Brucker <jpb@kernel.org>

Introduce a nr_contexts members to cla_domain to count the mapped
contexts. At the moment PL0 contexts share the domain, while PL1
contexts require exclusive assignment, since there is no context
save/restore. A negative count indicates the domain is exclusive.

Signed-off-by: Jean-Philippe Brucker <jpb@kernel.org>
---
 drivers/misc/arm-cla/arm-cla.h |  2 ++
 drivers/misc/arm-cla/cla-ctx.c | 44 ++++++++++++++++++++++++++++++++--
 2 files changed, 44 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/arm-cla/arm-cla.h b/drivers/misc/arm-cla/arm-cla.h
index c9ecab5ab6bf..43a58a329525 100644
--- a/drivers/misc/arm-cla/arm-cla.h
+++ b/drivers/misc/arm-cla/arm-cla.h
@@ -105,6 +105,7 @@ struct cla_dev {
  * @lock:		Protects the following members.
  * @ctxs:		All live contexts, keyed on cla_ctx_key.
  * @queued_ctxs:	Queue of contexts waiting for assignment.
+ * @nr_ctxs:		Context count. Negative value for exclusive assignment.
  * @worker:		Kthread worker to coordinate reassignment.
  * @reassign:		Delayed work that switches contexts with time slicing.
  *
@@ -120,6 +121,7 @@ struct cla_domain {
 
 	struct mutex lock;
 	bool broken;
+	long nr_ctxs;
 	struct rhashtable ctxs;
 	struct list_head queued_ctxs;
 	struct cla_ctx *assigned_ctx;
diff --git a/drivers/misc/arm-cla/cla-ctx.c b/drivers/misc/arm-cla/cla-ctx.c
index 0489bf7a103f..f956cc88909f 100644
--- a/drivers/misc/arm-cla/cla-ctx.c
+++ b/drivers/misc/arm-cla/cla-ctx.c
@@ -39,6 +39,38 @@ static inline void cla_ctx_put_pl1(struct cla_ctx *ctx)
 }
 #endif
 
+static int cla_domain_get(struct cla_domain *domain, bool share)
+{
+	lockdep_assert_held(&domain->lock);
+
+	if (share) {
+		/* Time share the domain with other contexts. */
+		if (domain->nr_ctxs < 0)
+			return -EBUSY;
+		domain->nr_ctxs++;
+		WARN_ON(domain->nr_ctxs < 0); /* LONG_MAX contexts?! */
+	} else {
+		/* Reserve the domain for exclusive assignment. */
+		if (domain->nr_ctxs != 0)
+			return -EBUSY;
+		domain->nr_ctxs--;
+	}
+	return 0;
+}
+
+/* Undo cla_domain_get() */
+static void cla_domain_put(struct cla_domain *domain)
+{
+	lockdep_assert_held(&domain->lock);
+
+	if (domain->nr_ctxs == -1)
+		domain->nr_ctxs = 0;
+	else if (domain->nr_ctxs > 0)
+		domain->nr_ctxs--;
+	else
+		WARN(1, "invalid domain refcount %ld\n", domain->nr_ctxs);
+}
+
 /**
  * cla_ctx_create - Create a context or increase its user count
  * @domain: CLA domain
@@ -53,7 +85,7 @@ struct cla_ctx *cla_ctx_create(struct cla_domain *domain,
 			       struct cla_ctx_key *key)
 {
 	struct cla_ctx *ctx;
-	int ret = -ENOMEM;
+	int ret;
 
 	mutex_lock(&domain->lock);
 	ctx = cla_domain_lookup_ctx(domain, key);
@@ -68,9 +100,14 @@ struct cla_ctx *cla_ctx_create(struct cla_domain *domain,
 		goto err_unlock;
 	}
 
+	ret = cla_domain_get(domain, key->type == CLA_CTX_PL0);
+	if (ret)
+		goto err_unlock;
+
+	ret = -ENOMEM;
 	ctx = kzalloc_obj(*ctx, GFP_KERNEL_ACCOUNT);
 	if (!ctx)
-		goto err_unlock;
+		goto err_put_domain;
 
 	kref_init(&ctx->refcnt);
 	refcount_set(&ctx->users, 1);
@@ -116,6 +153,8 @@ struct cla_ctx *cla_ctx_create(struct cla_domain *domain,
 		cla_ctx_put_pl1(ctx);
 	}
 	kfree(ctx);
+err_put_domain:
+	cla_domain_put(domain);
 err_unlock:
 	mutex_unlock(&domain->lock);
 	return ERR_PTR(ret);
@@ -161,6 +200,7 @@ void cla_ctx_destroy(struct cla_domain *domain, struct cla_ctx_key *key)
 	 */
 	if (domain->assigned_ctx == ctx)
 		cla_domain_schedule_reassignment(domain);
+	cla_domain_put(domain);
 	mutex_unlock(&domain->lock);
 
 	/* Release initial reference from cla_ctx_create(). */
-- 
2.43.0

