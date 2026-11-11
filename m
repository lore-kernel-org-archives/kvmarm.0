Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=90.155.92.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794436160;
	b=G3kyzVugGYfS/Kor0zlFMTEk5Dvjt3KbX6ANDObXksw5SyX5l+jHH/hBXt64JeigjGVC
	 UALO7f+M74fHo96pr1RV+vavVZSMixWaYgZS9cxHraLRMjPy895P6qdcnO1GMkGGkIgx7
	 ZPMyYgleL7pbcYgephQli7Nn85UtH0nc3A+dLw5XiVp91HYMwVCh2wDkc3afMKgEnfvV/
	 1F4JpLrq/VDDWiJYm/L77KU3gT+4zqB7Kr5KttKq5pdaYZTLBJD2C7v/steK6GfJ2PB08
	 Zy5niQlvklg0O3dHa5hKBT5OX1bWoqxgtnN7Ws385Dr+eqXH81zScsaJE/M5gGVcmOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794436160;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Sender:X-SRS-Rewrite;
	bh=8qybenYqvG8G9PhMhPtpqHZ056gMFT0pwcSnxKT9iyE=;
	b=jb0hymn3RhD3obHFExRllU8JXfi/Yv6munGuNnlZRimoWvntLUMiIew1yCFSEbdkwRAo
	 3Exic+nVGkWgU3TjFuVRPlj5HdJ4qwqctQG/mMXcuicdWqYbOoKc3jrt0kMhS2QyoRi6h
	 NCznMQF5Q07akZbA4fdaDjwfKAyx/kE5tM2dqI1YHhHM5SsS9k4jTQHT4nzrqGetRRjfQ
	 R2sTrtWpn2TpRz3QsRVswfmvvI5/Ii1aD6uOj9mxwQqZK/nGR/lXPvHCVAngElYr0Nh4v
	 W0W9L01gDV5LTQ9VzdLsjbVVSEhEoYkc+Kg82GVGhcI01XFNl+bZ1X3Oqt+FFLtw14g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=desiato.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=desiato.20200630 header.b=GTTbU0sn;
	arc=none smtp.remote-ip=90.155.92.199
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8E0C60A262E;
	Wed, 11 Nov 2026 22:29:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C8E0C60A262E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=desiato.20200630 header.b=GTTbU0sn
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=8qybenYqvG8G9PhMhPtpqHZ056gMFT0pwcSnxKT9iyE=; b=GTTbU0snO/nUQajge+xBq1MFqg
	QCVuIo3EK60swCUZBbdORPP9nzonwyf38wVn5CkrR4E+VbSwxUtREevKSLliFB6FkoA4U0PawrBC6
	21DVG1UqXCWYh8595L2Ac34v8l+N9Em9XG6MOE7cPxBGxDpGLbck/jzBxXsBA9L5afdyIarQH8c0Z
	w7w29b0ah/iBIIRVSrPjcp4hF3oE56z6pIjvpaUGM9Nyjm6z4yMxONuU0qhp079dLqajLEtUPtKCU
	wOMpaAYrFNfqQZpOFD++SIM+GIlqjp42fskxCot1POq9AKgO20oFdAjP691kKLoqXW6LMXgwjthK6
	Idrz/Zwg==;
Received: from [2001:8b0:10b:1::425] (helo=i7.infradead.org)
	by desiato.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xRGoc-00000009dba-29nz;
	Wed, 11 Nov 2026 22:29:14 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.99.5 #2 (Red Hat Linux))
	id 1xRGoZ-00000000081-2lp5;
	Wed, 11 Nov 2026 22:29:11 +0000
From: David Woodhouse <dwmw2@infradead.org>
To: =?UTF-8?q?J=C3=B6rg=20R=C3=B6del?= <joro@8bytes.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	ashish.kalra@amd.com,
	michael.roth@amd.com,
	nsaenz@amazon.com,
	anelkz@amazon.de,
	James.Bottomley@HansenPartnership.com,
	Melody Wang <huibo.wang@amd.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	kvm-riscv@lists.infradead.org,
	x86@kernel.org,
	coconut-svsm@lists.linux.dev,
	joerg.roedel@amd.com,
	Mushahid Hussain <hmushi@amazon.co.uk>,
	Sriram Nambakam <snambakam@linux.microsoft.com>,
	David Woodhouse <dwmw@amazon.co.uk>
Subject: [PATCH 04/16] KVM: Guard the per-plane KVM_SIGNAL_MSI cases with __KVM_HAVE_MSI
Date: Wed, 11 Nov 2026 14:28:59 -0800
Message-ID: <20261111222911.477-5-dwmw2@infradead.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261111222911.477-1-dwmw2@infradead.org>
References: <20260608144252.351443-1-joro@8bytes.org>
 <20261111222911.477-1-dwmw2@infradead.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html

From: David Woodhouse <dwmw@amazon.co.uk>

KVM_SIGNAL_MSI fails with -ENOTTY on both the VM fd and plane fds,
while KVM_CHECK_EXTENSION still reports KVM_CAP_SIGNAL_MSI. A VMM that
sends MSIs through the ioctl, such as QEMU with a split irqchip, cannot
inject device interrupts at all.

The new cases in kvm_vm_ioctl() and __kvm_plane_ioctl() test
CONFIG_HAVE_KVM_MSI, which no Kconfig defines; the macro architectures
set is __KVM_HAVE_MSI, as the old VM-fd case used. So both compile
away. Use __KVM_HAVE_MSI.

test_plane_msi in the x86 planes selftest, added later in this series,
catches this.

Fixes the per-plane KVM_SIGNAL_MSI cases added by "kvm: Make
KVM_SIGNAL_MSI per plane".

Fixes: https://lore.kernel.org/all/20260608144252.351443-39-joro@8bytes.org/
Reported-by: Sriram Nambakam <snambakam@linux.microsoft.com>
Closes: https://lore.kernel.org/all/20261104065536.15232-1-snambakam@linux.microsoft.com/
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 virt/kvm/kvm_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 0136156df252..95de904f0c61 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5016,7 +5016,7 @@ static long __kvm_plane_ioctl(struct kvm_plane *plane, unsigned int ioctl, unsig
 	case KVM_CREATE_VCPU:
 		r = kvm_plane_ioctl_create_vcpu(plane, arg);
 		break;
-#ifdef CONFIG_HAVE_KVM_MSI
+#ifdef __KVM_HAVE_MSI
 	case KVM_SIGNAL_MSI: {
 		void __user *argp = (void __user *)arg;
 		struct kvm_msi msi;
@@ -5662,7 +5662,7 @@ static long kvm_vm_ioctl(struct file *filp,
 		r = kvm_vm_ioctl_create_plane(kvm, arg);
 		break;
 	case KVM_CREATE_VCPU:
-#ifdef CONFIG_HAVE_KVM_MSI
+#ifdef __KVM_HAVE_MSI
 	case KVM_SIGNAL_MSI:
 #endif
 #ifdef CONFIG_HAVE_KVM_IRQ_ROUTING
-- 
2.50.1

