Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795589805;
	b=EamtGhJ53KCiWi7w+xE7MQHWYyFDvpoeme8oF1FXEERo/sK/gtoeWStmQ+fYJnq4EzRT
	 2xaC3zDWROgIsGxx7a0x3EFRHCw0Nz2LpTm7S1+1K4GclSg6NQJDCzvf2FrT4MX55e3zl
	 K4DGcBN45Zq6KMic3y4uNthfdrWihfZx1bHNkEAxSkxLqHVoEeBlFoi/DrfA+xk5gn6OH
	 yhvIOa47/EwQs/OscTB15/JtUQQ56oqsjy8DYXJM7Nsv98HmHJ62HlmVIfRLFA6q7mlRR
	 Fs+tIl9Y8YHjEe6VxPlPOKNKSze7NYFZfj929Zg/Wco+w+hvpii3SohAbgzp+kXn4sQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795589805;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer;
	bh=QoytpwQW2+7nMQ4LJ/J4mzx2IC+d/7ZRY8SoLyVie08=;
	b=HN4PIR23j8J/xoAngKSWcsp+kRtLirnQK/Ct+KYG3uiRfHU+SVLm0bITE/LeIILidpib
	 1nsbXAjxqpHtuQB/Mt7dnoxGJ10MMmYdUonqlQ+Ke7lqEYmgrlVguJoL76XF4B/NNBg16
	 +knAG+f3iPA8wiuLhKDwH1uXLBloVwq+O3v52SdNwBwpnoKUGcQvTPnoOkiH8euRnw7AW
	 5sdbcdoObEWDepYytVyRNadHFe8gcIv9T3tZCyPiInmUdTi670nh7PE5ZFcF6cNda8uiK
	 fdH9f2rTfgDDasRb2PpAPmYmTCGsM/1qvo6Eg7FUokaIxkVXk7MvuSPFzt+ugoEySOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pereq.eu;
	spf=pass smtp.mailfrom=cryspen.com;
	dkim=pass header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=gm6J3cGr;
	arc=none smtp.remote-ip=209.85.221.52
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 139BC606A331
	for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 06:56:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 139BC606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pereq.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cryspen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=gm6J3cGr
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-4acb44dcd7bso4646351f8f.0
        for <kvmarm@lists.linux.dev>; Tue, 24 Nov 2026 22:56:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pereq.eu; s=google; t=1795589803; x=1796194603; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QoytpwQW2+7nMQ4LJ/J4mzx2IC+d/7ZRY8SoLyVie08=;
        b=gm6J3cGrjyosa+7/gMSxRF8TW0WYfY/RD/9cn7eo2Y3WANVx0xKtxaNqiLDERi9Vxt
         ZrxuYGSsCE6VbemEKMAEByHINMhUM38Cl1ij5f4yc3nmuywXZbCY8t5XRSZHBmY5k10M
         WiAg1mbuqYhjDDykHGHovrNb76QaWqPgpByveEaUY9W+cd27d9VvZ/Xu/Qelbvmjltld
         ONhPm7lHzREdlxdPcorzyAMRn6Xt3gCN4dJfjbAH+/Tfj00oe2JJU6zsVZscbfcI5Nrb
         rD2HSZa/DkbO4BlFeMTK9ARA4YupaSPSz71rMwK5EvLw3IF+on+7eTNYJ4UmxNIfA+Di
         UCpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795589803; x=1796194603;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QoytpwQW2+7nMQ4LJ/J4mzx2IC+d/7ZRY8SoLyVie08=;
        b=Dbs/TW1lM2kI5yytfAWmPSdj5cAgSrJn4CNj7uZYLE12aGSKaNdsGSDtp4/w2PHxgV
         9ILqeMw2tU+cMN7f7unMbk/6Vk0WM+ydTnji28LGPtrmgdv5eb3r7/tPevKdP2IifDwi
         g8coZziBWPseqiImdj0m7qYXig16lzo9mnFbLMUa5F2yRzHBf/ow05HQCYk4vJ5at4kR
         KACerMlVn8Ze5gjU0ViXZbwpO3//Jh+HqmNKrK02LahgQrVUz/vsAYwU7oRGqJQUgxCl
         78K0Gzi/5Ek+GwHezVaD0aXx8kxJfT5qU07OnyR60uMin+HV+ifdkNQGHXT0+Ju7UIlI
         Gc+A==
X-Forwarded-Encrypted: i=1; AL+hErF899sUfR7q6ZT1pRISGpCxx5YqtX/OFqSVnczxUvKzkVETalVz07TA04FtlsiIVSYGzw/j+Oo=@lists.linux.dev
X-Gm-Message-State: APuU4Z9iNv1lGvLrp9tPvFPJ3lbQ+oBno5SUNcjJ7sxNMprDlkvKCxd3
	adUP7hgr1IZZr0WoAc2JsnJicztTXlNzNAaKJ/HkHFYvzwDcBd9QTcTUA5FKmv5i01s=
X-Gm-Gg: AZFdTZcYC7lI31s6rTtvrgfip4QTW4vZV9vOXMh5ohbc4h1Zt0ZD1um2rubiDmZ+NE/
	OEpN2Bw9XBtO8UV2ucjz1SSqSXS9Q5QX20WTFAnfZ4dNg4RBGdEkGI+umbih6HYHWILBnBsmowF
	tUc5OCDW4oS6+KIWmDoFIY8kekOj5XL1iiU3Spo+eX74q+FlpY/nSh+z7acxilbG4xGIHdM7Ol9
	XX7eZgq7ISg85pkOdoD/efOU6p9djZO8qkfreeSEPLzS02ez8IjqcEMTmaurv6c73Cn7v4maAin
	Rj1TPM1cYkYgj4urMhJcBglewY/wvROzu9NuD2AAH6vl7PXHVx+M5zX0r0KQz5CqzxxIRlkakwL
	Zml5N2fhVJ0C2fmxTnKLmjclpNw4V0IpHSaNuxJvvw/XRRegevRSR56oU8kxLaCdiK6c9AoIqV6
	wR+F+liGbZFGt0zB/cbDJY3anUt99S+GfFi6qUBEcLhKq2rBTA9Ep9lh/Ls7AgfTNG43N1X6sr8
	0bI/Kn6f+PkZ+/+MH4fwv9rgucgkgxCGvt5MOSFQmPsQN4km/WEaz/eqkgaCSBkIqS/gJ3KO9SW
	MJG2S4i0zmWRCKrYse4eNyxqaGtdT+967Nj//CjP
X-Received: by 2002:adf:e00a:0:20b0:490:1881:80ec with SMTP id ffacd0b85a97d-4abb3a4d2camr23594315f8f.36.1795589803330;
        Tue, 24 Nov 2026 22:56:43 -0800 (PST)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab69bf6804sm31864281f8f.10.2026.11.24.22.56.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 22:56:42 -0800 (PST)
From: Dan Carpenter <dan@pereq.eu>
Date: Wed, 25 Nov 2026 09:56:18 +0300
Subject: [PATCH v2 3/8] KVM: arm64: Discard a pending SError when resetting
 a vcpu
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261125-double_exception-v2-3-224689d8a764@pereq.eu>
References: <20261125-double_exception-v2-0-224689d8a764@pereq.eu>
In-Reply-To: <20261125-double_exception-v2-0-224689d8a764@pereq.eu>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
 Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
 Steffen Eiden <seiden@linux.ibm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>, 
 Christoffer Dall <c.dall@virtualopensystems.com>, 
 Rusty Russell <rusty@rustcorp.com.au>, 
 Marcelo Tosatti <mtosatti@redhat.com>, Sebastian Ott <sebott@redhat.com>, 
 Eric Auger <eric.auger@redhat.com>, James Morse <james.morse@arm.com>, 
 Paolo Bonzini <pbonzini@redhat.com>, 
 Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>
Cc: Karthik Bhargavan <karthik@pereq.eu>, 
 =?utf-8?q?Cl=C3=A9ment_Blaudeau?= <clement@cryspen.com>, 
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 Dan Carpenter <dan@pereq.eu>, linux-kernel@vger.kernel.org, 
 kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 stable@vger.kernel.org
X-Mailer: b4 0.16.0

Resetting a vcpu with the KVM_ARM_VCPU_INIT ioctl keeps a pending
SError.  We used to rely on vcpu_reset_hcr() to clear the SError but
commit f1ff3fc5209a ("KVM: arm64: unify code to prepare traps") changed
it to only reset HCR_EL2 before the vcpu's very first KVM_RUN.

If we reboot a guest while there is a pending SError then KVM delivers
it to the freshly booted guest.

Clear HCR_EL2.VSE in kvm_reset_vcpu().

Fixes: f1ff3fc5209a ("KVM: arm64: unify code to prepare traps")
Cc: stable@vger.kernel.org
Signed-off-by: Dan Carpenter <dan@pereq.eu>
---
v2: new patch
---
 arch/arm64/kvm/reset.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 9c1b42890c96..a5d298d5ce61 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -207,6 +207,9 @@ void kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 	/* Reset system registers */
 	kvm_reset_sys_regs(vcpu);
 
+	/* Discard a pending SError */
+	vcpu->arch.hcr_el2 &= ~HCR_EL2_VSE;
+
 	/*
 	 * Additional reset state handling that PSCI may have imposed on us.
 	 * Must be done after all the sys_reg reset.

-- 
2.53.0

