Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAC8878B53
	for <kvmarm@lists.linux.dev>; Mon,  4 Mar 2024 19:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709579094; cv=none; b=Ukjh8mm5pSuDeAPaX/4dSPN5TG044G3y7+8rAdSTF+9nUcITblXEUHh7JMjc1QJJkIMTh4hqE/9hQNpn51xpZCWkZi3OtNbZoi37/JU8STLQXZwZgR01zt/+6fxNWQxaGBdUNW4HjZDaoC/CM60WMMH1+sBhTUkTjcJO9nv9kZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709579094; c=relaxed/simple;
	bh=XRF9d0llZoljeVZTnT/w8TYniFhcPPtMCaXbelwBxIM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hu90AtjCqbCONH+Wu6URB2uKR4cAHl4kb9Oe6GQYiZ1aD7fYogFt0svOQ+TKSyrjQTSL9Sf2FBsB1oYalSnMSX/7JR1jGTI0I1f6oJMRgQo92Siice6IuTVC0Lhffid2O4ovqaFGESpWYtfCycjuWb5dw7dB6jBTBSLwriH4RHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aCeXAygA; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aCeXAygA"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc6dbdcfd39so9347803276.2
        for <kvmarm@lists.linux.dev>; Mon, 04 Mar 2024 11:04:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709579092; x=1710183892; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qigiTJmlQO5CEcsHaxPL7QMEFIyfo2CTnjsxN/Vximw=;
        b=aCeXAygACTat4ySvFkwUEcVBpdjquu+PIauba+HhBfakc+tTMRhYmFJmq7neeBIQ1C
         FsUieCWJPO/ZaH48TKOWEuVhZb+1pMJga7Cv0FgWpgbdJeS8mKMQSG6136aaXUPafmsM
         elL0Gmp7y0WQuAI38PLTQ327mpitGEarBRdhpNIsdHbgGZRJuyqnSJGZ8v+TwGewbaau
         yRVP7YODddLMTr0ULu8ejrtIYdpfjdOZ6klDjCYWdoSpz9tweHKiCFE6JPyfQeInobRZ
         pyiHrnp55mnDoHymhAI/79vcWJA7V+weCImOf3LpEFF2W5+KMXgDFdLSnxwYKHSr57X4
         UHZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709579092; x=1710183892;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qigiTJmlQO5CEcsHaxPL7QMEFIyfo2CTnjsxN/Vximw=;
        b=J9f3CKizTc4Q8MECQmmOgD6Ni0+AB0oMC8q12ekuPkZabnfbuPTAbXRrcnUEVPpJMV
         vSCn+ntHvyjrt6E0XFlmpa3M7+DH9aDTEzDRXRHdmBnAySnG11dwHrgFSgI8UbanI1D+
         ToexkD9EZPMquR9lr+Ncpw17+27V+W7fQ/Cy7aYJlvcfVPG9ON1KegakvcvfexQ4lsRO
         gT7xt+sfiobuHM7BQNvvfWQa26VE8r4UuBKR8VbEzPGKZePO/Sw6i7W4e18jTAmf0UQp
         15e5OHSR/JigwbbOrEme2XId9gjs55RiC1Sgm/OhU9hiK4DjqIOEEpnrp1FZmySu2tDd
         9XFA==
X-Forwarded-Encrypted: i=1; AJvYcCWxNo4eUF26J7W0o4bNGQGSc/OKfrNNe4B7kDhJBVf9XYvnwZJCh9fbCi38qD77U74tQ7b9TviqYEOSEBEAnNeEBcnykU5i
X-Gm-Message-State: AOJu0YwRkmtbBv00KeZ8+DjvI5zU+DQ+zFfClta1XcbcCZ0gbq09Ira8
	dLdTmVSc3ZBvMHCd+wUNJ6hAAWdy7l8FhvmRyfbInx7v/cUa4CgpA3caGdH9lMmsiQR77NCX7Qi
	dUQ==
X-Google-Smtp-Source: AGHT+IG99XprlSdu2d42OzIQNXRQobjTVbkqOIhrS78D9U8gTWrmjRueDnAOyhYjkl87zP6p7oPrASHYRb0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:2183:b0:dc7:68b5:4f21 with SMTP id
 dl3-20020a056902218300b00dc768b54f21mr2615442ybb.9.1709579091951; Mon, 04 Mar
 2024 11:04:51 -0800 (PST)
Date: Mon, 4 Mar 2024 11:04:50 -0800
In-Reply-To: <ZeXAOit6O0stdxw3@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <40a8fb34-868f-4e19-9f98-7516948fc740@redhat.com>
 <20240226105258596-0800.eberman@hu-eberman-lv.qualcomm.com>
 <925f8f5d-c356-4c20-a6a5-dd7efde5ee86@redhat.com> <Zd8PY504BOwMR4jO@google.com>
 <755911e5-8d4a-4e24-89c7-a087a26ec5f6@redhat.com> <Zd8qvwQ05xBDXEkp@google.com>
 <99a94a42-2781-4d48-8b8c-004e95db6bb5@redhat.com> <Zd82V1aY-ZDyaG8U@google.com>
 <fc486cb4-0fe3-403f-b5e6-26d2140fcef9@redhat.com> <ZeXAOit6O0stdxw3@google.com>
Message-ID: <ZeYbUjiIkPevjrRR@google.com>
Subject: Re: folio_mmapped
From: Sean Christopherson <seanjc@google.com>
To: Quentin Perret <qperret@google.com>
Cc: David Hildenbrand <david@redhat.com>, Matthew Wilcox <willy@infradead.org>, Fuad Tabba <tabba@google.com>, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, 
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com, 
	quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com, 
	oliver.upton@linux.dev, maz@kernel.org, will@kernel.org, keirf@google.com, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Mar 04, 2024, Quentin Perret wrote:
> > As discussed in the sub-thread, that might still be required.
> > 
> > One could think about completely forbidding GUP on these mmap'ed
> > guest-memfds. But likely, there might be use cases in the future where you
> > want to use GUP on shared memory inside a guest_memfd.
> > 
> > (the iouring example I gave might currently not work because
> > FOLL_PIN|FOLL_LONGTERM|FOLL_WRITE only works on shmem+hugetlb, and
> > guest_memfd will likely not be detected as shmem; 8ac268436e6d contains some
> > details)
> 
> Perhaps it would be wise to start with GUP being forbidden if the
> current users do not need it (not sure if that is the case in Android,
> I'll check) ? We can always relax this constraint later when/if the
> use-cases arise, which is obviously much harder to do the other way
> around.

+1000.  At least on the KVM side, I would like to be as conservative as possible
when it comes to letting anything other than the guest access guest_memfd.
