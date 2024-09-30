Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F387717332B
	for <kvmarm@lists.linux.dev>; Mon, 30 Sep 2024 22:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727736509; cv=none; b=SChvtShOqB7pmGmtCxqLKM6q04fKhA4C8o7EQrZOLYvHmvlBbjduhrCBfgGvBoK0IoeuP6qZm+lxb2ygk81ObqYWhmnxWUOt+KBAWQgG1GQqKrstspbWzBLYQuUA6uHiTf/7LTi7lsYD87IMYD6EeoH7udGstxu33IBNLXqwRIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727736509; c=relaxed/simple;
	bh=S2Z1JwX1MU6DLUEoEGwV8nRjiTHOC576ZcrLMcIfVj0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Content-Type; b=TtXR1T34HM5oU3ztoXnoowD7azjdVJnTPQa571O0svHBIOaZbnuKXfVrB7BraowD+v+1Hhb8aqc9omvaP0eu6Nm0NH8FL1LRcOAY/NM6GJDEAQC5GecB+l/CTfM9vBXwwCWWzD/Sg7/hUm7tqzS2Of9O8aGmJs2EGbCQ80Anxb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bSULvwDb; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bSULvwDb"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-717dfdd7c72so5481373b3a.0
        for <kvmarm@lists.linux.dev>; Mon, 30 Sep 2024 15:48:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727736507; x=1728341307; darn=lists.linux.dev;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XEKROrbsF+Qc32qai9a0qLWUFdx11pYvvS7Yvup4cZY=;
        b=bSULvwDbC60vw895ucg6jFvY1aYSA6MChfrSSMNv+ka9N868oWKe3tpZSWvFqN+qSg
         QDrsowf788yEQN6j5L8g2ZFra+BHCtlw2NIz4IrTGboUgYgBmWn5oi30jZzASeHVe3JS
         ewCeMsi7g7aSm7/xKwP+kXgrwq9Kpwc84GrH6ik6OqlxuumjWvMNh/glyCGFVbgNg7s1
         GuXP4sZIx6k7a1c8Ee3phqjHXyET6nhFrSnCS+5/MZfCLDO9qh2p25eVVMDnXjqz97bx
         A84fNObUG0j+v7A9dExaIpA80nz9vmw58ZKXjHVCIgdOQOSSiCGGtBjgvb+2BwIRSh8T
         J64w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727736507; x=1728341307;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XEKROrbsF+Qc32qai9a0qLWUFdx11pYvvS7Yvup4cZY=;
        b=SsbtEU9P6z746rYNXXYU8rkbPheLDaowhHmu/D/XzHKyTSCDtSdefcnSnwfV9Rtib5
         W0jIJYBNN04Y2lYqh+Pb8Hgz40VPP3RRXX+VYcGigxXcJjieqfsdjRgxVppWy1Q6Chl7
         qsIcdAfoxzokHBVkIOfWR01IiBJzbzQut9xQapGosqSUVa9nyNRHKM75KZmMxfcIL9fv
         6/WS00pzsPyEvflI3JRHOe6T+iHEPp2JsQ1Jhy7L5YNZY7R8IIamSF8cTWuNWUVj1x4+
         pDDi1c+UxC8/kptJqQVeGI0e7UbFwI/YTu4f5vN4ofZ+xZ56TPP4RdcOgojh19pLmLio
         Hxfw==
X-Forwarded-Encrypted: i=1; AJvYcCVn0V9nGKGXKZKLBSiSHdaj1Geh924d0/rmiKxnVpiPQOgZYbpHmryxLj6EaYYwbNN+lm92WyM=@lists.linux.dev
X-Gm-Message-State: AOJu0YwIVJh3OvkPzwKqyTxwZW9dWqZeYHV0JFulorW/wolaPgAFlsqn
	JnZDZdb8fCT1lFRGSkwbMT3MUcM6Z4LIUfRBDsGjeq8P18jN/UsN7s/WcoJYEya1ZFTjIGpPgsR
	JIQ==
X-Google-Smtp-Source: AGHT+IFBqE4b3ETKHUb3GkTpAmeIZlaPPTKak751rxnBHWeoFOgyWmnqPX8beCCGnb8n0RirfB1L8PS0CMc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:83ca:0:b0:718:d8af:4551 with SMTP id
 d2e1a72fcca58-71b25f2ca30mr23827b3a.1.1727736507148; Mon, 30 Sep 2024
 15:48:27 -0700 (PDT)
Date: Mon, 30 Sep 2024 15:48:25 -0700
In-Reply-To: <ZvseoZLzmaS4MEbc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240911204158.2034295-1-seanjc@google.com> <20240911204158.2034295-4-seanjc@google.com>
 <ZvseoZLzmaS4MEbc@google.com>
Message-ID: <Zvsquaq-Lo4umoTI@google.com>
Subject: Re: [PATCH v2 03/13] KVM: selftests: Fudge around an apparent gcc bug
 in arm64's PMU test
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Sep 30, 2024, Sean Christopherson wrote:
> On Wed, Sep 11, 2024, Sean Christopherson wrote:
> > Use u64_replace_bits() instead of u64p_replace_bits() to set PMCR.N in
> > arm64's vPMU counter access test to fudge around what appears to be a gcc
> > bug.  With the recent change to have vcpu_get_reg() return a value in lieu
> > of an out-param, some versions of gcc completely ignore the operation
> > performed by set_pmcr_n(), i.e. ignore the output param.
> 
> Filed a gcc bug: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=116912
> 
> I'll report back if anything interesting comes out of that bug.

Well, there goes several hours that I'll never get back.  Selftests are compiled
with -O2, which enables strict-aliasing optimizations, and "unsigned long" and
"unsigned long long" technically don't alias despite being the same size on 64-bit
builds, so the compiler is allowed to optimize away the load.  *sigh*

I'll replace this with a patch to disable strict-aliasing, which the kernel has
done since forever (literally predates git).  Grr.

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 48d32c5aa3eb..a6f92129bb02 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -235,10 +235,10 @@ CFLAGS += -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=gnu99 \
        -Wno-gnu-variable-sized-type-not-at-end -MD -MP -DCONFIG_64BIT \
        -fno-builtin-memcmp -fno-builtin-memcpy \
        -fno-builtin-memset -fno-builtin-strnlen \
-       -fno-stack-protector -fno-PIE -I$(LINUX_TOOL_INCLUDE) \
-       -I$(LINUX_TOOL_ARCH_INCLUDE) -I$(LINUX_HDR_PATH) -Iinclude \
-       -I$(<D) -Iinclude/$(ARCH_DIR) -I ../rseq -I.. $(EXTRA_CFLAGS) \
-       $(KHDR_INCLUDES)
+       -fno-stack-protector -fno-PIE -fno-strict-aliasing \
+       -I$(LINUX_TOOL_INCLUDE) -I$(LINUX_TOOL_ARCH_INCLUDE) \
+       -I$(LINUX_HDR_PATH) -Iinclude -I$(<D) -Iinclude/$(ARCH_DIR) \
+       -I ../rseq -I.. $(EXTRA_CFLAGS) $(KHDR_INCLUDES)
