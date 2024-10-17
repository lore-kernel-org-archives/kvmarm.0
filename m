Received: from smtpbg156.qq.com (smtpbg156.qq.com [15.184.82.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B05C4502B
	for <kvmarm@lists.linux.dev>; Thu, 17 Oct 2024 06:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=15.184.82.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729145723; cv=none; b=gQfcW7myLbj0sVmkbuhs3jndTU7nd9cqa5CCaXCRR2QBFa7bUqC1aYa0UTTkhgq8adCru+eEWaXGl8YiSiBUpEgR1q/NIUl7vf/XcRo9f7OBDfwk6vlAG66s1LfD+rAm1+CsFYUF1HM3cTIVAJbaiAhgcD4Gx8SybCioDoC+YMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729145723; c=relaxed/simple;
	bh=QuwHsti+BEFxd1GuNg6SPmi9WOz/qDElc/ktA+gI/+w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CJCEw/Iq9v7tIW74nrMc0avAZQmKYtDAswZeN/VN9sxkr3U0EtonAgcuK6P7hga3YKWFF+XiQw3kdLyPHXeKHrHyjr8JggQdKdoC33LbiXeLQkQpo/0/Uls7Nf6AKRIsnDLNLKyQTYRxj4y4boLq2dfr4GbnC+toQRYAlT03Aio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=h69ar9II; arc=none smtp.client-ip=15.184.82.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="h69ar9II"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1729145626;
	bh=hA4hUN+9KBWHFCEFczU3MeRYWfArLynwxZaFIvHd2oQ=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=h69ar9IICG9t9Gvoz4CEfc75c7ZodsKdkcnAN5eRkUopodeP4UkAHGFoDbI/4on4e
	 Nhk5eM6ZfbVuD2ckWFBJGOOsqBPTAXGNBWsZJh1jk/sZ7aD3fXwQwiUEvhd+PidV0Q
	 ki0u19djg63d1NvgcQ0Zx6mP33dbziKrm4YvMROw=
X-QQ-mid: bizesmtpsz4t1729145617taeiv3x
X-QQ-Originating-IP: uYtshKjOGBnpjT4JIwF/uJpPdH4CCOgdEKjvuAdhe+g=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 17 Oct 2024 14:13:35 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 12168614839949333599
From: WangYuli <wangyuli@uniontech.com>
To: maz@kernel.org,
	oliver.upton@linux.dev,
	james.morse@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	rdunlap@infradead.org,
	sebott@redhat.com
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	guanwentao@uniontech.com,
	zhanjun@uniontech.com,
	WangYuli <wangyuli@uniontech.com>,
	stable@vger.kernel.org
Subject: [PATCH] KVM: arm64: vgic-its: Do not call vgic_put_irq() within vgic_its_inject_cached_translation()
Date: Thu, 17 Oct 2024 14:13:34 +0800
Message-ID: <FEBA39FEBDA1C9D7+20241017061334.222103-1-wangyuli@uniontech.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz8a-1
X-QQ-XMAILINFO: Mm/Yx8ZY6QnDL0vQ5ZRRuuBcY6wyS+yuf9CAkzWF5K99u/tRzQ+/stRh
	IU13GfE5sajErRHDaTni4di69HGo9lSbwjySFzdTgaR6Vw9goww7Kz4Xitsnv5DCuST3FFS
	EWrQpn4+YyD/rZXHysnxQr2Rz8qx2HIamINO2wcF0Q000EceoO3+zxzBDod9UcNF1k+qHIC
	apf5wCkuGovoGZZuMNfWmHxWMrTjBdVgH2G5nrZ2JTM8X1qKJORAV1hvayp2+x9/yfBRU6+
	lKPC2gTA8V0vZzjJVPFIPVrv2HWB7JOQPl60avA/8D6NXCaMrx2JnTgTVFfnLqY6dDi0jFc
	aP1sC4cSq3QUCHoDnl4wIfjyiTPODyZx+m1vv/2lqGvL9L0g8MJtiIB23aHJM9h97zI7PZ/
	uEm5sTNwfd6NqIib23sgwMZukdms7J7oX92aygObVqNHwqw+YFRRjdLlLt36V8Gp6I8fFO7
	b/FctHl44whxmC8Ev68Bzu9LXhjhxDNgmmG39zqQShAP+Esq50DVVSFJxonjQLhBzU5s9wP
	grdm49BIZnrnEz5fv9azaUbLvOeKuhFjOFplU0ij3Jp7SiBMY4oF08jESrgE76Mn58DOGJj
	MpJpqesW0njFeDE75yGvWw+/UXhmD2QIQ9eFpWMfj/cdn3xWQjIWo6ilKWmxsyCiJjhcaTM
	El8JNOjWt7oppVmQi2cdNiy04qk+/DZ56BmTXAwaFoZKoWUPcXJwHArBR8bvc4PpJQQqSUS
	bJp36XLBXWe72tk2fNmdcwN6AWkjzHLvIwLdSapK5kklwUc9tpd7GYQvKrXal3cGZTu1D44
	gUKTdECI9G/LZN42PxbZse0q1Q6XKReN5fTBKkMJJ2CwlmPIwI4wdQiUG+AKLVdLfj+Lg5/
	h1BKD+YPTihftPqAkAfhmf+7tINli/G1D97c9MliNwM+0NR7jwQ7CDWVTqH9MmOb315VX9c
	RBZrv/EZCfQM2bcy2DqKN8AWjqEX7ymPskZp/T0NFQh/ClRrDPuo9od2Db7wC9onyPtSXJG
	oSvtHIGTYO2KI8/Clb
X-QQ-XMRINFO: NyFYKkN4Ny6FSmKK/uo/jdU=
X-QQ-RECHKSPAM: 0

There is a probability that the host machine will also restart
when the virtual machine is restarting.

Commit ad362fe07fec ("KVM: arm64: vgic-its: Avoid potential UAF
in LPI translation cache") released the reference count of an IRQ
when it shouldn't have. This led to a situation where, when the
system finally released the IRQ, it found that the structure had
already been freed, triggering a
'refcount_t: underflow; use-after-free' error.

In fact, the function "vgic_put_irq" should be called by
"vgic_its_inject_cached_translation" instead of
"vgic_its_trigger_msi".

Call trace:
  its_free_ite+0x90/0xa0
  vgic_its_free_device+0x3c/0xa0
  vgic_its_destroy+0x4c/0xb8
  kvm_put_kvm+0x214/0x358
  kvm_vcpu_release+0x24/0x38
  __fput+0x84/0x278
  ____fput+0x20/0x30
  task_work_run+0xcc/0x190
  do_exit+0x36c/0xa88
  do_group_exit+0x4c/0xb8
  __arm64_sys_exit_group+0x24/0x28
  invoke_syscall+0x54/0x120
  el0_svc_common.constprop.4+0x16c/0x1f0
  do_el0_svc+0x34/0xb0
  el0_svc+0x1c/0x28
  el0_sync_handler+0x8c/0xb0
  el0_sync+0x148/0x180

Fixes: ad362fe07fec ("KVM: arm64: vgic-its: Avoid potential UAF in LPI translation cache")
Cc: stable@vger.kernel.org
Signed-off-by: Wenyao Hai <haiwenyao@uniontech.com>
Signed-off-by: WangYuli <wangyuli@uniontech.com>
---
 arch/arm64/kvm/vgic/vgic-its.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index ba945ba78cc7..fb5f57cbab42 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -679,6 +679,7 @@ static int vgic_its_trigger_msi(struct kvm *kvm, struct vgic_its *its,
 	raw_spin_lock_irqsave(&irq->irq_lock, flags);
 	irq->pending_latch = true;
 	vgic_queue_irq_unlock(kvm, irq, flags);
+	vgic_put_irq(kvm, irq);
 
 	return 0;
 }
@@ -697,7 +698,6 @@ int vgic_its_inject_cached_translation(struct kvm *kvm, struct kvm_msi *msi)
 	raw_spin_lock_irqsave(&irq->irq_lock, flags);
 	irq->pending_latch = true;
 	vgic_queue_irq_unlock(kvm, irq, flags);
-	vgic_put_irq(kvm, irq);
 
 	return 0;
 }
-- 
2.45.2

