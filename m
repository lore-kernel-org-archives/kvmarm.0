Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 042EF73196
	for <kvmarm@lists.linux.dev>; Thu, 14 Mar 2024 20:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710447920; cv=none; b=NvenNBs3ymD2cLihh5ep0YbAGcPnSMVBApWWZVPmDJWLuGTRpZV97v0IgdYgZlwW4J5rLg+W13inPmYRTLs0OZr2cxT4QnMOo5ghB11EB/CDuv27m5wuH0vdzmUE4es0kdaCzrxp/h+OSfHqnQk70rz7CwXh8uGNu1IZBfZIXPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710447920; c=relaxed/simple;
	bh=cyQ2uR1WtWqFRxYPGfl+1TVBx2dUPQERmNqiM8XpAQQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dwq989IQAuKjy9fJ/F1gyTge2+b90alQxWZOO1e/jBEkNoKuxJQ37oakAL0fSpPM6Pe83ojnPaGcmnfmOFWxTKk1ALacerocV6AhKXXcPjr9DDfhl6xIy8kRk27rJOBPBehrRPa4Rq7tIHdk3aVbSnazm7ExUz6+J6jTOICKve8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zxlkSyEY; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zxlkSyEY"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a44e3176120so179706466b.1
        for <kvmarm@lists.linux.dev>; Thu, 14 Mar 2024 13:25:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710447917; x=1711052717; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=pRLwYMgl/UDUGVtTi+ey3Tg5z5Sm2xHrvmETTv6ml0c=;
        b=zxlkSyEYf5kgYnfAwkfryblej+d4adqYX2NIFUUxjaG6UDGbxF3Wqe+Q+k8wJqo1Jf
         kGXqeDdBLorldL9xVH0GseaEb4Xi/WBLVgO181C8ihtPXpnYvJqPmUDWkxgC8Q7yctRe
         1Xrhafhd91fQYHU5U01S4i/IOreNrvSEveC8zCyEmRECtdE5GkwiEQM2TKHHMHiCG12B
         BHwZjX3vR5l3l9qSPa+l0VHgzsJN6NIITMSRMeF484qm/nt4CT3pYuxuJ6HolVu7uwzY
         1Tdq8OsN56brJL0MzA2PBXYYGNZX3TSptIHkdzgSSBx185eXTgvAq9MK0X2qDzioSxVa
         +T9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710447917; x=1711052717;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pRLwYMgl/UDUGVtTi+ey3Tg5z5Sm2xHrvmETTv6ml0c=;
        b=F5FlDSl3PkWLkTs1ki4cDoAD4AsS2fCEm9WpC5+tV0VuGINgSGNekFHgS6DJ0XV8/a
         ZjCRS4MPsJXFSkRjnMA5ELPKnVupHJPsgyVguzNB4bWYhh3flvIBa3dDNE8tEykvFKwx
         wI44oybwF7Wg64RFW6cTi7QEIYag5sXyoSqej1+8jFQ1W2W9CQawpSin6DUf3RiokDXc
         xOBmHDpdd9R3akIL1TmnvbRcdtCWDmyyr/hSZP3H0LQafZz+y+8RVosrz/KFOz50Rmc4
         aRMW9f+v5D4uDvF9SiSOhOpg5rjyBQn9PZTDuCe3wLDYQwHDSHlju9ctc2+xqNFyHNer
         uvDA==
X-Gm-Message-State: AOJu0YyTM08dCeROri0mgau6b6Ty5lQJJY+2nHECAKJsg2ye2j7S/6p8
	vppCWwlqad1eTyqobWzadFcjDV13s7XtRgw5uLqC0z4BuQ/nYsNzmUXirYRy85r7PIBGDaQ4KId
	2UxO7
X-Google-Smtp-Source: AGHT+IHiMpX8oq69CsmwoWeCDboIKyc9/3ET5RDJwETpARBSad/uPBpvw4EMATrK/2Ae9kiiUviJAw==
X-Received: by 2002:a17:906:260e:b0:a46:13a9:b7af with SMTP id h14-20020a170906260e00b00a4613a9b7afmr83924ejc.47.1710447917073;
        Thu, 14 Mar 2024 13:25:17 -0700 (PDT)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id l5-20020a1709066b8500b00a4320e22b31sm1025367ejr.19.2024.03.14.13.25.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Mar 2024 13:25:16 -0700 (PDT)
Date: Thu, 14 Mar 2024 20:25:12 +0000
From: =?utf-8?Q?Pierre-Cl=C3=A9ment?= Tosi <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>, Marc Zyngier <maz@kernel.org>
Subject: [PATCH 07/10] KVM: arm64: VHE: Mark __hyp_call_panic __noreturn
Message-ID: <b5c4f8953cfe7073c0adfe83499b56ecaa314741.1710446682.git.ptosi@google.com>
References: <cover.1710446682.git.ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cover.1710446682.git.ptosi@google.com>

Given that the sole purpose of __hyp_call_panic() is to call panic(), a
__noreturn function, give it the __noreturn attribute, removing the need
for its caller to use unreachable().

Signed-off-by: Pierre-Clément Tosi <ptosi@google.com>
---
 arch/arm64/kvm/hyp/vhe/switch.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 1581df6aec87..9db04a286398 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -301,7 +301,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	return ret;
 }
 
-static void __hyp_call_panic(u64 spsr, u64 elr, u64 par)
+static void __noreturn __hyp_call_panic(u64 spsr, u64 elr, u64 par)
 {
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_vcpu *vcpu;
@@ -326,7 +326,6 @@ void __noreturn hyp_panic(void)
 	u64 par = read_sysreg_par();
 
 	__hyp_call_panic(spsr, elr, par);
-	unreachable();
 }
 
 asmlinkage void kvm_unexpected_el2_exception(void)

-- 
Pierre
