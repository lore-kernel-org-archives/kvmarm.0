Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C43D17BC1
	for <kvmarm@lists.linux.dev>; Thu, 22 Feb 2024 22:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708641735; cv=none; b=OUaQcKSEkZTxQllzgDvRZIMbdlB435T1sem1qagyfRdfrvFsf8Usp4xKBrXbJFIbfUkJ/Oh/4luaIhEnWBrhuh7sr+am2CXpL3wSgAKOeqou9jGeqlVK2f8ZDhLdAdsnxBnnietAFRNl+Ctokh6maMyHbxrTQp/l8ask4tIRK1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708641735; c=relaxed/simple;
	bh=imYlGZaDB2n5vfS4ZwIvsXZiZqAKg8o6WkaCZH5L1Qw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Content-Type; b=uzRIpRfZumTpDrm0lh1KsOx4t6XGCFO1LwdIKYH7SoYzvqKSYwDYTF3ya5mFgu1AvbS0+F2ttx9t5bQSpGoyXZnKVJtHqmy8tu83YSVPs9Af0JqAiPv63rdGWlPSMfh5/2unofqA4CuBuhe2rftEoEFFA4wcBxKN5bahRPH0sDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KotHSBeP; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KotHSBeP"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-608575317f8so4400577b3.3
        for <kvmarm@lists.linux.dev>; Thu, 22 Feb 2024 14:42:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708641732; x=1709246532; darn=lists.linux.dev;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jFvVQg9UZb065hqoLsESeNre8JaYtsdQOcTRgkYVRKY=;
        b=KotHSBePEqLbMhAUm6yt9pANQ4z7OY2Ie544J2sCLD8dgKQyMZvC+FgF11l6mGUY3W
         klBSE+q1YXltbXOTj5ME61hMucbdVIcS22FXcy/HPtQ130kT8BXzBybTzZNNR7TqjV2f
         4K16vrQbEhEyqYHx2HyYvjhYq3CuGmFRtXOsHKVquiORYnvNmPXTAmZvft10D27mcbll
         GkzmljK5uCBT5XGK5HyoIlwmhsSV8VQOmcQGoH1tw2guOntqLH4mNmZpx3zWXEelfw7Q
         Uuml2FlDNHAMAOZ8FUY44cCW4rGO/n0e4/62HsddhvY6hq0rfb18F7ZHo07asR3tUxJ1
         GDzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708641732; x=1709246532;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jFvVQg9UZb065hqoLsESeNre8JaYtsdQOcTRgkYVRKY=;
        b=R073Km/Xb4Zio7OqQNkefzgCjP+X3HZDYMGx8n3pKVFUDjrM91ZY+FLTgArvTi4zuF
         gerbZZeff80E+s4CUKeVzAa3C+msHYPtHd24FpJs19rPCJIFrSNmXHFnnjvxtRddMeZK
         zfY8QSg5wxRH4wjZRc59a9dHKZZJ6zRzy3ZJW4cMVsyc6Ijhz/+lFHoXYUHFT4nWutOJ
         mTGVyg/7oAXrRRmgk3s+laiWsWQqYUQp8ffrz3qy6ZqwN1R+pxO1kDta4OLyQD0XDiyh
         7cGQVN2LNtXy46KVVXiXMfYbSKahaUXZNiz1kVcye0h+0SU9wEsOoajSfqBlm3fEPkdG
         WW0A==
X-Forwarded-Encrypted: i=1; AJvYcCU4fWkrKXVn3eBPfZm0xDv8lQYaolsh/u6y46zZid31+f1DpWbHKYPhiCo+8DvRKDczFZiA2KxUooPuRxQMr2WUTrRPGrN3
X-Gm-Message-State: AOJu0Yw7bQ5qjI8n2m2ZANeR6w4vmxsAJq4cbrUgmv8ETN3ivk8mZEvd
	T6I9j+fRtOeEStUU6FD7kKznHl4cSeEsbhkevrACK8oE3jbZvosUQYz//z7PNUYBzO4D7839V2Q
	JDw==
X-Google-Smtp-Source: AGHT+IEn84VsOMK3xly4fJg9p4ZGQL4jC+l+k5U6BnNNTDUyy7r/Gzq9iPM6OigIQq722pMhxaceeSC3g0o=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:9242:0:b0:608:20df:8b0a with SMTP id
 j63-20020a819242000000b0060820df8b0amr102171ywg.6.1708641732562; Thu, 22 Feb
 2024 14:42:12 -0800 (PST)
Date: Thu, 22 Feb 2024 14:42:10 -0800
In-Reply-To: <ZcKYRsNUAngWGy2a@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240203000917.376631-1-seanjc@google.com> <20240203000917.376631-11-seanjc@google.com>
 <ZcKYRsNUAngWGy2a@google.com>
Message-ID: <ZdfNwhe2s0Mn2gB4@google.com>
Subject: Re: [PATCH v8 10/10] KVM: selftests: Add a basic SEV smoke test
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Vishal Annapurve <vannapurve@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Andrew Jones <andrew.jones@linux.dev>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, 
	Peter Gonda <pgonda@google.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Feb 06, 2024, Sean Christopherson wrote:
> On Fri, Feb 02, 2024, Sean Christopherson wrote:
> > +int main(int argc, char *argv[])
> > +{
> > +	TEST_REQUIRE(is_kvm_sev_supported());
> 
> This also needs
> 
> 	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_SEV));
> 
> to handle the case where the platform supports SEV, i.e. /dev/sev exists, but
> KVM doesn't support SEV, e.g. if TDP is disabled, if SEV was explicitly disabled
> via module param, etc.

Thinking more about this, I think we should simply delete is_kvm_sev_supported().
(a) it obviously doesn't query _KVM_ support, and (b) if KVM says SEV is supported,
then it darn well actually be supported.
