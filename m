Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02A6A56B66
	for <kvmarm@lists.linux.dev>; Mon, 11 Mar 2024 16:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710174078; cv=none; b=KIphV82ZfaKo/9Ms9FeZB9AKdSHJYLBHpm/6Y1k/3Ndi3YeN9clRyOfTpkJN2KaC44dTmmjtxuk6/h9xujVlZ+aF1Eni1xd0FM950y2YK13747egdrxKizBlqQdlAlzDPWoTZfuY2AWc83EN5xgvgf4duHBx7oRQT3u9ecOh0EA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710174078; c=relaxed/simple;
	bh=qfW/kGk94of4yalWU1PdrhO6UqJZB7rHcs/wXkg7FPs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XMWaSwNvaOqpAULHyRHs9uqhlzLEsucMH4D+OSxUXpPlxYDFnLWVWuPlkzAwFRDVvRxP/YdTaK3fKRTSrlci5sc1iMg8BL+4eaXeql/P6rERp9ml2boZ7Xo1Sk3QQWreW9vMmTredenkL15BZRvI14RmPLDsv/96/WCgwKrOnfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TYssF2E7; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TYssF2E7"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4133100bccdso917635e9.0
        for <kvmarm@lists.linux.dev>; Mon, 11 Mar 2024 09:21:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710174075; x=1710778875; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GRHbM8iISI0NpUPhNykIpu2WvmXC88NjtQH+HPjZyOE=;
        b=TYssF2E7ZHTZnH3vbAPirDZsIr2AKKboKg977tWGi+79Tgmdx1CVWcU17xCv2IIZQY
         Re/IsnPFz5F0lmZFc1i3KZpmJ6kzqbq3XMoHZgt88as2ngHcY5eNqtUo3fl47PopalTj
         iZyZl1Lt2EgfjBppJaNLMj2pf18haddxao/R9cDQQeOdeYbkslinJE2RbwWw3UYB7khC
         Dt5SUrpuYMXEpSYB/2GYHQm6IGPuABj5SZbkl34ipo7fmRNCeEDz4XC4Kn8l7bUbVw5A
         noMZcveIh3eLMQI8hCVXH1ozQFwWlS6LXvTYph9FXyW73mdurmpaljNGiMsonc6h4gqc
         HnSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710174075; x=1710778875;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GRHbM8iISI0NpUPhNykIpu2WvmXC88NjtQH+HPjZyOE=;
        b=Oy0vj1FpTY6zC5v8K4jhamlect82lkmXPNNwxFSGr0aXzjiil6tk/IpGKSyyzh3B38
         8AqXiFrwH8wv+uqkv9//OJvc6J5rSDDMnW/+6oJqDIwv8+tiQDf8Io0brJv2aC4ertpx
         hqOyanIJAd3pN2+XwRpcKpx5mTn0oWFLE7fvZ9YjrK7eI6KETVhZ6mPzFoyEIle6k+d1
         +JpkJCG1fYYkOwIIc8cn1z4qZu2CYw4nvCoUmnWkhqqFiAEyPdn0M12eNSBYa3YIAD/G
         dvNIqllRAdo/qHUYCTS3C4kf6QQEjq1aBNzMVLYqIMaEz0EPaY18hIRMJF9w1kQcnIiO
         jt2A==
X-Forwarded-Encrypted: i=1; AJvYcCWTRliNwpn12UJtZom5BNHdt+VPGlRcx/4BoyJ+6YgjkOY0i1rebs16xlapIdujUCGMEeDgDgbnSe1YgIjcKQkHghUSSEgM
X-Gm-Message-State: AOJu0YxqHE2cW+knwaSAmCB3sQSSQjGMVD5gpmeYZYXydoWha4IXHfd9
	qo5DVTlvZ7Bk8lRe9gPDdyn2uvOfAYooHm5fjHMtTv76yia1Xk3fjZA7J9ZKw7JOWh/QE/mOj2g
	mKcac6eh/po3svimrBL4oehGI6lK6Cs579HOC
X-Google-Smtp-Source: AGHT+IF56DFAkN6EElW+sbMpfmisqZTBEkWDtxHyybNyRdtF973BKWpFHFSULcS7yyvYlMJ74IiC8WSzDEoEJJADSJA=
X-Received: by 2002:adf:dd8a:0:b0:33e:69a5:68f9 with SMTP id
 x10-20020adfdd8a000000b0033e69a568f9mr5462424wrl.17.1710174075303; Mon, 11
 Mar 2024 09:21:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240215235405.368539-1-amoorthy@google.com> <20240215235405.368539-7-amoorthy@google.com>
 <ZeuMEdQTFADDSFkX@google.com> <ZeuxaHlZzI4qnnFq@google.com> <Ze6Md/RF8Lbg38Rf@thinky-boi>
In-Reply-To: <Ze6Md/RF8Lbg38Rf@thinky-boi>
From: David Matlack <dmatlack@google.com>
Date: Mon, 11 Mar 2024 09:20:48 -0700
Message-ID: <CALzav=cMrt8jhCKZSJL+76L=PUZLBH7D=Uo-5Cd1vBOoEja0Nw@mail.gmail.com>
Subject: Re: [PATCH v7 06/14] KVM: Add memslot flag to let userspace force an
 exit on missing hva mappings
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Sean Christopherson <seanjc@google.com>, Anish Moorthy <amoorthy@google.com>, maz@kernel.org, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 10, 2024 at 9:46=E2=80=AFPM Oliver Upton <oliver.upton@linux.de=
v> wrote:
> > >
> > >   2. What is your best guess as to when KVM userfault patches will be=
 available,
> > >      even if only in RFC form?
> >
> > We're aiming for the end of April for RFC with KVM/ARM support.
>
> Just to make sure everyone is read in on what this entails -- is this
> the implementation that only worries about vCPUs touching non-present
> memory, leaving the question of other UAPIs that consume guest memory
> (e.g. GIC/ITS table save/restore) up for further discussion?

Yes. The initial version will only support returning to userspace on
invalid vCPU accesses with KVM_EXIT_MEMORY_FAULT. Non-vCPU accesses to
invalid pages (e.g. GIC/ITS table save/restore) will trigger an error
return from __gfn_to_hva_many() (which will cause the corresponding
ioctl to fail). It will be userspace's responsibility to clear the
invalid attribute before invoking those ioctls.

For x86 we may need an blocking kernel-to-userspace notification
mechanism for code paths in the emulator, but we'd like to investigate
and discuss if there are any other cleaner alternatives before going
too far down that route.
