Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05502664C6
	for <kvmarm@lists.linux.dev>; Fri, 13 Jun 2025 22:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749854894; cv=none; b=BK5k+CoojexnT5Cnzj8Qkl0jp39QeQUv/VqheQpOO/SQy4MZPLOQLtbtPoxB3yVu5hx94ZpUb7mdIlCq41T7bwalnuugxzfLGLEXyhPWhkV49x0823ojwGoCbbyP+ulbm4EjuqdpgFRv7xGu4Gc4XLM/BMv9rYNZCvGemfrrdFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749854894; c=relaxed/simple;
	bh=b2f4UfTd6Ie3E6DBleQTiYYTSPeearnB2GRwzHGTHi4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DcYEDz9gKPXbWMrhXB/bjU7tnHv4oxkmCg1UP/UbdGoP4caU3e6p4AtRRO7oGq1DPECl9HknRiLzKACgh+5UCPWvPLVZ/+YnSaA8r+WLbMVCpX+O/kpcNA2rG+/+109jbM1SvDF769S+3iAkdPmglQIOXtm6HISUBjngoAknfQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=k7Lg5IaJ; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="k7Lg5IaJ"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-311a6b43ed7so2164438a91.1
        for <kvmarm@lists.linux.dev>; Fri, 13 Jun 2025 15:48:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749854892; x=1750459692; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=I0pEZjx6fVkzLwzb7Tf4p6SavBE34NRSvbWnq2Fu6u8=;
        b=k7Lg5IaJ4JUp4Ut7bgbLmmpJSVNObZaxvSvN2UwiGUTINCuY5l0VUDdJ9sSd3tuFHn
         MULgsuzB8yzShaduEqxAZTkQwROkDqCdnE5ZGsmQL1E0VVV/lfb/GH5s2rTzJX35TfNq
         2vgNRQi49eqV0ToBfLqjC+/ewKNgQZs9gcLTGihRedZzbbij9XiRxBW6RgMmGLprwCTE
         uRseBtdr6typOfXe7Z16k3sosph3Z7pV7qsKnDhCfvt4YrZ2XwCcoXzOMlwTK47VC43H
         WArT7wTlYY6rQwh6RD3+desGsBpj5DoQ1lQoswRiqgdLEnOOBz15zHQO5B+ovJ1uleCJ
         rPcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749854892; x=1750459692;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I0pEZjx6fVkzLwzb7Tf4p6SavBE34NRSvbWnq2Fu6u8=;
        b=vtM4XtW5m3oS4zheC+9giN15BBrsni0/LZG37a8DnNcPQq6iZBobiJt0EJw7uiZbw/
         YqW2c8Ps+qooxsofgUt/M0VoHUv2a13B7cnYtV1oYWkSYe7yEFnZDbJuO+VlzLQg3RtZ
         jrhVxQo5KmcJTa68WPPCvLPZtvb4ZfXBf+ID615knBOMA3KCDJAGyjFf3EFg5++WzOoG
         /CDzpJncdQ1/8EK9vxFtEd5PBoTrSq6mdo7TOg6pHtnt2nO+DGlgujowPbBuVIqK8uqZ
         v7mxbk318P7pUPh45MUQ98f/0XrxNDvhkOoozn1vZaSDwDgg+eXluHYRf/MpPXiowKtE
         g3/g==
X-Forwarded-Encrypted: i=1; AJvYcCUezAJbrYKw9fwE2FLxmhIatKTFVuYQqrI5xn8CYfJdD7JfirBL0xdDNrKVgOzuzHMjT1irSXs=@lists.linux.dev
X-Gm-Message-State: AOJu0YziXsO9yWFDzrFHObRfk2vy8ss8KqAffCQCtDUL2KMN4QaJivCP
	L8l2uRei0MsAfJI/WJsIvLkkUFVkmLC2X2UzNVYE0I5HlduUe4WvN2GjGbN4G/XYlic5kb3WHos
	9Z1NktA==
X-Google-Smtp-Source: AGHT+IFmVbuER09bqe0w/t1NnKGFZRyDNJUVfxGfFpjqY6vikPqb0P4dso4PSiLkCEX/Cq6o353w4bjW7uU=
X-Received: from pjbdy14.prod.google.com ([2002:a17:90b:6ce:b0:313:274d:3007])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:e7c6:b0:312:b4a:6342
 with SMTP id 98e67ed59e1d1-313f1dd5483mr2147790a91.33.1749854892347; Fri, 13
 Jun 2025 15:48:12 -0700 (PDT)
Date: Fri, 13 Jun 2025 15:48:10 -0700
In-Reply-To: <aEySD5XoxKbkcuEZ@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250611133330.1514028-1-tabba@google.com> <20250611133330.1514028-9-tabba@google.com>
 <aEySD5XoxKbkcuEZ@google.com>
Message-ID: <aEyqqj77hIAZy8FL@google.com>
Subject: Re: [PATCH v12 08/18] KVM: guest_memfd: Allow host to map guest_memfd pages
From: Sean Christopherson <seanjc@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Jun 13, 2025, Sean Christopherson wrote:
> On Wed, Jun 11, 2025, Fuad Tabba wrote:

...

> > +static vm_fault_t kvm_gmem_fault_shared(struct vm_fault *vmf)
> 
> And to my point about "shared", this is also very confusing, because there are
> zero checks in here about shared vs. private.

Heh, and amusingly (to me at least), I was the one that suggested this name[*]:

 : >  static vm_fault_t kvm_gmem_fault(struct vm_fault *vmf)
 :
 : This should be something like kvm_gmem_fault_shared() make it abundantly clear
 : what's being done.  Because it too me a few looks to realize this is faulting
 : memory into host userspace, not into the guest.

Though I don't think my two statements are contradictory.  A bare kvm_gmem_fault()
is confusing because it's ambigous.  kvm_gmem_fault_shared() is confusing because
"shared" is (IMO) bad terminology.

E.g. to me, this is much more obvious:

  static vm_fault_t kvm_gmem_fault_user(struct vm_fault *vmf)

or even

  static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)

if we're worried about "user" getting confused with supervisor vs. user in the
guest.

[*] https://lore.kernel.org/all/Z-3UGmcCwJtaP-yF@google.com
