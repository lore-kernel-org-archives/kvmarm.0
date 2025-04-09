Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C21A158DAC
	for <kvmarm@lists.linux.dev>; Wed,  9 Apr 2025 01:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744162923; cv=none; b=Bqh0N4kFCZDvyikW3jYAeWcaKm+ChFFBUTgVQL0Gf8moJVC6vLp2zo0hkvTe7QacChnx7Ep/1MJyFKYQRB2fS6md0x4ne5B9vGZZCOkJrMQ9u7puXCNHvH2BQXXS6HLvvOTI0VdmKpJiiA25gaLRVJNzDyGKCLFm3LY2nz7l10I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744162923; c=relaxed/simple;
	bh=Mmr+9lhJqZZzoEoO+XRdi5Oquv1oYt27Mf+xN8Jv0bs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=b6GLitAUQ7jHiOtuXKWilaz18P/5yFXyzv4w1g+nUi0d8u3smwVdqvpV08QYNncCxem4+tN3IH8TJwZps7uiZF1dh6R44AFTpHoqKiHWx5Z9ozxRlfCv1053ya6MqY0QGlbFWohxaqFno7E7Kf82XGgG6gQLd5aYaImDzIwH8Kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ox5KmXl2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ox5KmXl2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744162920;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LhiIhuo/fjhkoyOs0BBqrbek6FZF30QwERtnCpHBTlw=;
	b=Ox5KmXl2F6lLAHAidSkcprBhG4GruKScl5e9xy+GGHJwPIIpHLA5BaDzpFDvo5ORrVkaRq
	oqNeMcLziKxdbVTnstcBPVPYVZjffQj+MPY85GA0H4GnXUYNYwvt26fh1gEBcaynEaCARH
	DlOQKlGYtXMnkCVSLvOUgR5QO8Ul3A4=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-173-bshH0SpeOH-i_bIS38j1zQ-1; Tue,
 08 Apr 2025 21:41:57 -0400
X-MC-Unique: bshH0SpeOH-i_bIS38j1zQ-1
X-Mimecast-MFC-AGG-ID: bshH0SpeOH-i_bIS38j1zQ_1744162914
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 077561956080;
	Wed,  9 Apr 2025 01:41:52 +0000 (UTC)
Received: from starship.lan (unknown [10.22.65.191])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8497F180174E;
	Wed,  9 Apr 2025 01:41:45 +0000 (UTC)
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: Alexander Potapenko <glider@google.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	kvm-riscv@lists.infradead.org,
	Oliver Upton <oliver.upton@linux.dev>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Jing Zhang <jingzhangos@google.com>,
	Waiman Long <longman@redhat.com>,
	x86@kernel.org,
	Kunkun Jiang <jiangkunkun@huawei.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Anup Patel <anup@brainfault.org>,
	Albert Ou <aou@eecs.berkeley.edu>,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Zenghui Yu <yuzenghui@huawei.com>,
	Borislav Petkov <bp@alien8.de>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Keisuke Nishimura <keisuke.nishimura@inria.fr>,
	Sebastian Ott <sebott@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Atish Patra <atishp@atishpatra.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Will Deacon <will@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	linux-riscv@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sean Christopherson <seanjc@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH v2 1/4] locking/mutex: implement mutex_trylock_nested
Date: Tue,  8 Apr 2025 21:41:33 -0400
Message-Id: <20250409014136.2816971-2-mlevitsk@redhat.com>
In-Reply-To: <20250409014136.2816971-1-mlevitsk@redhat.com>
References: <20250409014136.2816971-1-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Allow to specify the lockdep subclass in mutex_trylock
instead of hardcoding it to 0.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 include/linux/mutex.h  |  8 ++++++++
 kernel/locking/mutex.c | 14 +++++++++++---
 2 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index 2143d05116be..ea568d6c4c68 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -193,7 +193,15 @@ extern void mutex_lock_io(struct mutex *lock);
  *
  * Returns 1 if the mutex has been acquired successfully, and 0 on contention.
  */
+
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+extern int mutex_trylock_nested(struct mutex *lock, unsigned int subclass);
+#define mutex_trylock(lock) mutex_trylock_nested(lock, 0)
+#else
 extern int mutex_trylock(struct mutex *lock);
+#define mutex_trylock_nested(lock, subclass) mutex_trylock(lock)
+#endif
+
 extern void mutex_unlock(struct mutex *lock);
 
 extern int atomic_dec_and_mutex_lock(atomic_t *cnt, struct mutex *lock);
diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index 555e2b3a665a..5e3078865f2b 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -1062,6 +1062,7 @@ __ww_mutex_lock_interruptible_slowpath(struct ww_mutex *lock,
 
 #endif
 
+#ifndef CONFIG_DEBUG_LOCK_ALLOC
 /**
  * mutex_trylock - try to acquire the mutex, without waiting
  * @lock: the mutex to be acquired
@@ -1077,18 +1078,25 @@ __ww_mutex_lock_interruptible_slowpath(struct ww_mutex *lock,
  * mutex must be released by the same task that acquired it.
  */
 int __sched mutex_trylock(struct mutex *lock)
+{
+	MUTEX_WARN_ON(lock->magic != lock);
+	return __mutex_trylock(lock);
+}
+EXPORT_SYMBOL(mutex_trylock);
+#else
+int __sched mutex_trylock_nested(struct mutex *lock, unsigned int subclass)
 {
 	bool locked;
 
 	MUTEX_WARN_ON(lock->magic != lock);
-
 	locked = __mutex_trylock(lock);
 	if (locked)
-		mutex_acquire(&lock->dep_map, 0, 1, _RET_IP_);
+		mutex_acquire(&lock->dep_map, subclass, 1, _RET_IP_);
 
 	return locked;
 }
-EXPORT_SYMBOL(mutex_trylock);
+EXPORT_SYMBOL(mutex_trylock_nested);
+#endif
 
 #ifndef CONFIG_DEBUG_LOCK_ALLOC
 int __sched
-- 
2.26.3

