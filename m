Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65557183064
	for <kvmarm@lists.linux.dev>; Wed, 12 Jun 2024 18:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718215862; cv=none; b=ivrx4WsoA9JhFqIgmkOF+V7Yq3G6aTbQ28EpDgK+UIhgCWZkHN/NFWqtFcQJk0uZIvMjFOEmZadrYPSnsZOKkzUOcgYg0EF9UjGCgJjiNFCEjsbTPURggtHW+T3GRGnWIO0noH6LF0t9dWuD2nm/YIcVPoj8EQYMiVU1dwFBPC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718215862; c=relaxed/simple;
	bh=byfky6BG4g1mjW3Wr/3DNMmcw/qupLWQ0lVzTwpwdZo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cZXhaZrl5vn1sr8JusHkTepuxgqQoYqcvepgNiv7THa/MAhscjjAYnBNn2kKOwDFJV7X5WuOHD6oLcoecG7WhCN95aPeb7x075x/lMZqg41lg82zniD3rZgwPzY7ZHLAkjDy3m4vDAH08u6D1uSeybWBXBgg3F2G69+O/26jWXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AWSohfhH; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AWSohfhH"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6300aeb93dcso2993127b3.0
        for <kvmarm@lists.linux.dev>; Wed, 12 Jun 2024 11:11:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718215860; x=1718820660; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bysuRKx6ASJn7sotbzdgYdmXjsZucWIObzR9RYJqi4M=;
        b=AWSohfhHqoFQ27+xWA3lsbXj9mZ7dud6uI/rC67VIlyMaYSnJpqPT+aWJTtEOAd497
         pGhcm3oStBwfe4DV2YFEIVTxasZi4hV2vI/BDMr65hT/kb3xWSHJHZ7vM4s1Ctp5vxTz
         S8N7B6KRB5jMirdrvAFWVSkZC43Vf6WcwNT7Z8C+xQkaPuFU2sIX+Yz2CbNhiTDXtneL
         6IvU1I+MnNu5bsbzL2dTpaN8g3DCo2wdcGy5y6oMSN0mizHmsF+/BBddQ3zr/1YcG0u/
         7JfzpAOHGdjlmCYOqTq+Scpe6C1KhCbIu5z9UF5BxryiuQCclHf8u3KjwH+L1DVB3+5e
         tDfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718215860; x=1718820660;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bysuRKx6ASJn7sotbzdgYdmXjsZucWIObzR9RYJqi4M=;
        b=V3b+TQ0owq13JdT+ClMgeR7X+jXXcGZ4PW+VkkP1IApwg8tvfA/Hl2hBt93b81jt2n
         RyREHMChMYFs0D+tB4EAeJYmTmwKyR1k6jEvUaSNyjUls+kfvKrSanIYYPHlF+TCOBCq
         4iPEpE8JXMbdhJl4Inic2YlGj/T+we04oxq+lYiJdnp1DPh9hoMRwnvY1qXoh0mkrslx
         P1le9mJE1OOqAaGU8wpIwYQE7Qv+fJ9FyJVEzTUukhAGz6OQMhcOQIgruEKnKw4yoLDz
         Ewk6xjMHsVmQyKf/4itrphCz21aTOKxxyot+ExGFiuPEs6rweYG+9EtE0Yu3oNvM/5AX
         pJNQ==
X-Forwarded-Encrypted: i=1; AJvYcCWnp1++mG7d+1dhW7clPb64GOjbs1pId/TI1Z77zBqqUbpYnFNhyR+n7BqOBWX+9yrIhtJrrELIrPW9VaObHSiEiXECzXJv
X-Gm-Message-State: AOJu0YxXHataYiW5EyCE6Tr6k0mUKMHH5yNTl9qq0o11KrifnJhIUDoE
	nMMaLOyuFWCVix4SYcedM/wEMGEnZZulkNga0ZRmL70ZrahYzbtExDsJM/ypWrNst16yAtpK9Cr
	uEA==
X-Google-Smtp-Source: AGHT+IFdlsyNfCopJx9MGc/lpAH0uLI55vrBd5uBQ720M/Quh9qtzfjG5LFD+1WcYsruY1pOCRVfaawqImE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:b19b:0:b0:de4:654f:9ad0 with SMTP id
 3f1490d57ef6-dfe66b65b58mr79044276.6.1718215860399; Wed, 12 Jun 2024 11:11:00
 -0700 (PDT)
Date: Wed, 12 Jun 2024 11:10:58 -0700
In-Reply-To: <6bd821a3-9dbe-499c-ae17-afce70076299@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240612104500.425012-1-usama.anjum@collabora.com> <6bd821a3-9dbe-499c-ae17-afce70076299@arm.com>
Message-ID: <ZmnksmC4u5lP5am9@google.com>
Subject: Re: [PATCH 1/2] selftests: kvm: remove print_skip()
From: Sean Christopherson <seanjc@google.com>
To: Dev Jain <dev.jain@arm.com>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, David Hildenbrand <david@redhat.com>, 
	Haibo Xu <haibo1.xu@intel.com>, Anup Patel <anup@brainfault.org>, 
	Andrew Jones <ajones@ventanamicro.com>, Aaron Lewis <aaronlewis@google.com>, 
	Thomas Huth <thuth@redhat.com>, Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, kernel@collabora.com, 
	Shuah Khan <skhan@linuxfoundation.org>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Jun 12, 2024, Dev Jain wrote:
> 
> On 6/12/24 16:14, Muhammad Usama Anjum wrote:
> > 
> > 
> > diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
> > index 4f5881d4ef66d..695c45635d257 100644
> > --- a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
> > +++ b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
> > @@ -144,10 +144,9 @@ int main(int argc, char *argv[])
> >   	free((void *)hv_cpuid_entries);
> >   	if (!kvm_cpu_has(X86_FEATURE_VMX) ||
> > -	    !kvm_has_cap(KVM_CAP_HYPERV_ENLIGHTENED_VMCS)) {
> > -		print_skip("Enlightened VMCS is unsupported");
> > -		goto do_sys;
> > -	}
> > +	    !kvm_has_cap(KVM_CAP_HYPERV_ENLIGHTENED_VMCS))
> > +		ksft_exit_skip("Enlightened VMCS is unsupported\n");
> > +
> 
> Isn't it incorrect to delete 'goto do_sys'? ksft_exit_skip() will exit and the
> program will never jump to that label. At other places too you have deleted the 'goto'.

Ya, exiting instead of continuing on will break these tests.
