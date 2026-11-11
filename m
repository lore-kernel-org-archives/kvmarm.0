Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794395487;
	b=xzJ5zgvwFpCDKQZVPcie3bRr7pMye8nDdJg5Whm8TcFjg28gX/aNInf8/cG8GOAo5f9h
	 UhcpM6miW03jABQ5CUB7eks0/fn48JT9IKLOmH2HShtu+Gmjd/zmvIEPGTnDdXn1kzQsK
	 5XeFBnXUvLQn/C+j63qutZAK/QKQeZvNeJXz/bPEwuVgqA0UMIcEKgFtm3MTpD2thCj7L
	 nj93u5+nhHL8wUTqNxMds3jDYxO5BbpU/3xFeGIZDBQfoq8Ef3iLsjO7bW5n2Whodlj2q
	 ZoHL1St3bG1kdrjf4RnPeHnBf/c1Ah1JfK7n2idxSQxe+txEeUbnK6JzXCXPIu4v3zw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794395487;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:MIME-Version:Content-Type:Content-Disposition;
	bh=ml3p/AxADI1kPwVB1ta2/1LkU6QgLRbPMaZJLAyCaWY=;
	b=CJi0tC1p1cDwm+DAzABknc7/C1mw8YBf89bmFVEM3Ln8In/e+/DNzg5A5/g3XsrHtnzw
	 cKUO36qOEQa2iUA/0d8FhWquqyyGngtL3J0FYaeyhwe7AWwk62W5aTB7bTB9R6K6ysdnx
	 Z7BprG5V/1Dp/DZLQW93MT2qOq+QxxHkZvaSYICtzmN/2A33IFFVkQ3RwL4DIWILm+ilB
	 ktiNLaJOYUNSiu0QWhd9Vh9T8XiuzX8z6iMI3fmctZg4qI7+4h7ZfoNYZpZf196vlVWAl
	 TcwlWe/zIIGeT26r1LVrm4lje9F1dpiDlQN+f5iqeCuiR+UwU2lyf2vcoXXS/A+SNRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=cryspen.com;
	spf=pass smtp.mailfrom=gmail.com;
	arc=none smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F2F4606A32E
	for <kvmarm@lists.linux.dev>; Wed, 11 Nov 2026 11:11:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0F2F4606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cryspen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a3517554f7so32090445e9.2
        for <kvmarm@lists.linux.dev>; Wed, 11 Nov 2026 03:11:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794395485; x=1795000285;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ml3p/AxADI1kPwVB1ta2/1LkU6QgLRbPMaZJLAyCaWY=;
        b=gcF9HVRIRTirJcvbg1JdX/yg568lfo1YPGP/2EDWvHxt1/1tjN9iHhXzugPCwDQn9i
         DvAAqPGDfJC379pzMFMA0FtlpzUqfdK1InUW0sKKjm8bbwvWKlmWBb1Skapf/HYnAY5w
         zmuShdqdb94EZPdOZUxOo44rNqk+DRpJ+IN7jcu88gEqtm6aPbSs5iRMem17o+Bobxgn
         4t6NVIz2Z+qjJu0dsE7qU2bUhACzVoziKosdcWSFojJ8jjGSwtvk38ozZIFH2+cOeEs3
         VWra3NDakkSTp7jiUi5yVGEIxG7HyhZcDmrnMhmeaU1K93f5la80+Gsawm9TUkbaVMEX
         8qXw==
X-Forwarded-Encrypted: i=1; AL+hErHHkG5Mrzmfn8zS3eJMlk/wWZXTwb+NQrYM868jf8IkgOurN8e1fhARYcDMei7KoPQamjshQYo=@lists.linux.dev
X-Gm-Message-State: APuU4Z+krkrh8jH+nGz+7aQph6pIiQqAMb96y6nUrG5S5R2bqbxwpfv9
	IQF+EDL+jFrQSDw9PxtIyuWbtXbF1vnNEIENSmMedO3Tw6hfnfLzjOSK
X-Gm-Gg: AYBFou0rOnqo+q0iWNw4YZCyOGP6+96bEpPrf9M3RTosEOtqDOgJrnlDEvDZzLPjRHx
	M3gYexWTOXH7E3XgF2m9KgnxgzUsPV8AHlYIvSBcBiomoqCCXj8ozWhT73SUbIHSnIz4w3gtzRQ
	Ubh7owfvJ+e7F6yi7/sAjpGbtDQ7dEotcwwjwhsQ6N3MXW/ac35sD5KCNHc1mUSYAmYvp7XLAbh
	6LaclS0ybAaTn95lI26jDageizcah2Sewiz1UJvPQcly27ZpV5zlEUcFhIQRyhWkDsqccg4mSZO
	RycgyMjrO+vy7HDqDTZ+c0J/9Nh/60LBMYzVM+CRmL4Ducq3zm22vkn4FPfwa53NTzR59ev07o0
	iBkqt2g8+suYMAy4J9qddPH33kEzefntIG2JM0N39BiPyhV4WJEzoZjvoASDMPHt3GC1O0QI3FY
	L5DHNnf/nOyH7vaHxsPu/2OAsNXOqrP+vrjw70jakwg2ZwHDzm47zyTSxrQjm77nXXV7CKk8erC
	OA5Z2qllHSV2Rwg4dbPrM/VhpcrXKpJ0Wo5h3CPCm2ADFRxZZgJag+OGVjs2SB+I6z8baBlAo4N
	dSxYQRmkjIf2UfNdde57Jv/4vqBmw9beVTeOPvSFkEARMONumxUGGmMmxAwzL/5ig3hW8P+Rlcn
	EFciO3ew95hUf3nLJIexWQ/kqgfw/R5h1Pg7bHZOqFPQUNj6XVXvpgV/yiZ0EoAoe
X-Received: by 2002:a05:600c:a0c:b0:4b8:4af2:88b3 with SMTP id 5b1f17b1804b1-4ba0938b7f3mr40085265e9.22.1794395485364;
        Wed, 11 Nov 2026 03:11:25 -0800 (PST)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4ba02043149sm125436565e9.8.2026.11.11.03.11.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 03:11:23 -0800 (PST)
Date: Wed, 11 Nov 2026 14:11:19 +0300
From: Dan Carpenter <dan@cryspen.com>
To: Oliver Upton <oupton@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Karthik Bhargavan <karthik@pereq.eu>,
	=?iso-8859-1?Q?Cl=E9ment?= Blaudeau <clement@cryspen.com>
Subject: [PATCH] KVM: arm64: nv: Initialize hw_mmu to NULL for nested vCPUs
Message-ID: <d3571fb535e1832d2a067649f294b83d824d4350.1794395321.git.dan@cryspen.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Before commit 6ded46b5a4fd ("KVM: arm64: nv: Keep reference on stage-2
MMU when scheduled out"), kvm_vcpu_load_hw_mmu() would set ->hw_mmu on
every load.  Now it only sets it when it is set to NULL.

In kvm_vcpu_init_nested() the vcpu->arch.hw_mmu points to &kvm->arch.mmu
from when it was set in kvm_arch_vcpu_create().

Normally what happens next is a two step process.  KVM_ARM_VCPU_INIT
calls kvm_reset_vcpu_core() and that sets the vcpu into hyp context
(vEL2).  Then KVM_RUN calls kvm_vcpu_load_hw_mmu() which doesn't do
anything.  But that is fine because we are in hyp context and the
->hw_mmu already is pointing to the correct place.

However if, for example, we are restoring a vcpu that was saved in L2
context, then the VMM uses KVM_SET_ONE_REG to overwrite the vEL2 state
that kvm_reset_vcpu_core() set up, and the vCPU is in L2 context when
KVM_RUN loads it for the first time.  Ideally, kvm_vcpu_load_hw_mmu()
would set the hw_mm to point to L2's page tables but, since is non-NULL,
it leaves it as is.  At this point L2 can access L1's memory.

Fix this bug but setting ->hw_mmu to NULL in kvm_vcpu_init_nested() so
that kvm_vcpu_load_hw_mmu() always sets it correctly on the first load.

Fixes: 6ded46b5a4fd ("KVM: arm64: nv: Keep reference on stage-2 MMU when scheduled out")
Cc: stable@vger.kernel.org
Signed-off-by: Dan Carpenter <dan@cryspen.com>
---
 arch/arm64/kvm/nested.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 78fa433774c6..60bccb66e52c 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -140,6 +140,8 @@ int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)
 		kvm->arch.nested_mmus_size += S2_MMU_PER_VCPU;
 	}
 
+	vcpu->arch.hw_mmu = NULL;
+
 	return 0;
 }
 
-- 
2.53.0

