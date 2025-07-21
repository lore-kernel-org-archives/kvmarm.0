Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B1728A400
	for <kvmarm@lists.linux.dev>; Mon, 21 Jul 2025 14:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753109745; cv=none; b=caaTUz5W/yNl3XdwyETkFCRRpO1vQeGq2VlMdmq/PIgt1x1piPkDMatKNj5mnHGwaFgvC94R9v7MvTkVAFnx4SbOmDqbTMsLGg93QenbqKvNigqa6t6cIV05I71WaH4B8oz2vZSI6b4hWczt0oGozHosEino3X6Z0tjdlWa+qhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753109745; c=relaxed/simple;
	bh=T92uPXfYGURbpMpAnfHw3K02jpN+sfhbXqSdhB3YZ0Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kk6MtHc3gHIvI2Lts1mYebdmP9HPZJDO9RXRFTQxbIqPZgE5AY6xalstlXoRak1CPADIf73S+eGINxXIaljDQ0Rb34h7WDaG1I/978bSbzB6zAKihIuGP73xirW6XK+5cVx3X1UcNvKfHVCP5f5TY42EJAIvsWDMYl3MSWFWt2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KdcutbDx; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KdcutbDx"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4ab3855fca3so492601cf.1
        for <kvmarm@lists.linux.dev>; Mon, 21 Jul 2025 07:55:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753109743; x=1753714543; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=62Qcferz2ta5LRJ88jGpd09cdn6J94mnG93fNoCzAck=;
        b=KdcutbDxqoaXRAzViPBW5gVZsTPkXx/VTAXr9O3Mc8PBPp1PtXdoxrsmPX1kkpIZ4E
         1jGC3WrJ0nC2GpImat7kV06xuP3blfheY+/jxdFxJusZqE2mxLJN6elj7cmEKHJrqHvB
         CM271DM5pJQ23I8mb6l0S3qE16o7FhYuRSS4b1+gNF0vIXi3BLC5BmE2rOVsjkQTCM/a
         KKtby1QfVzlRF64gzmn/a+dq5LVDlqNWp5lKNW/YiQLOHk1tzngB0AN/5afaLADkcaDi
         l6GKhyw80ANHKcxRkVoHghbAV62VQ9wRhXIWQFIpXiDwljgHx0N9agUw4QD14MTMZkB5
         CqjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753109743; x=1753714543;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=62Qcferz2ta5LRJ88jGpd09cdn6J94mnG93fNoCzAck=;
        b=ww4q83K2l3HST3plQweea0hYv8LzaZMvaNOzzMPG72FNKOC0NIJMCbmgvnIiAPaxfX
         wMotsSxluv5S4bI3AOTC9a3HazRiAeycCgnQf5phtZGWd8kZhgTSPWiuUpcl5UA6vngX
         OSqCCxh1JbSc0iJrPGdCsnXht01YGD9vf3TRG2zy69KPW0EMvCg0tByHVbAdJubo70yS
         bay9b9baKxMbjsRRd7L5E7PsrpigUWrddHdwQYB8tHDZM50H6Hy9quVaj7Z4j+YpY+yd
         wmn5w12aqFy1mNxNKTRZ92i2YmgJDwMVaxqQ6qG1rzo8+9ymfsLKFcnI6ERvxwM7mqTM
         9CdA==
X-Forwarded-Encrypted: i=1; AJvYcCUY5z3TgurjzlRT7RAei7WzVukOPDkhlS0B+XX8bhMiyPd9vIvZE0jfi1ZXq3Lf1chnfLiP4Z0=@lists.linux.dev
X-Gm-Message-State: AOJu0YxL4l5wO8N2WbyeD74pSk+Zk7VHYk/KlcSGC7Db2QdpGPwAxvP3
	PCOgwOHhHuBtjid1qfTvRxXQlyv4uCrDdXEbwVk4HvuklXrxnLy5wxfz8IhE9B3qtEh+9gpiq6u
	XFBkzEPXP/I55BK8ZqinJx3Pq4j96R6WJa+MtMCiH
X-Gm-Gg: ASbGncsjs9BjahRX9Hu8YmoTRjn89DJyZqjFx+FX7luzIrHlSRCUzgZK1JvjY4OiTJo
	hxzNPZpsSSM72BLqrY+oB+AzxJ6rMIgpfU4swLG3wS0Lvaa9PVuevAKBXQN81RdauP2fH8DBIDI
	6ISNc5FI7MpMNROfSxqTpiA917P/1DOTt1C+nfx+ilq3LlH+92nFWwO7sz27oVCeE4Ln/gPRedh
	1JaoWk=
X-Google-Smtp-Source: AGHT+IGTWuuHynD3kVjQ3ZKHxL2xoSxYhOwKveCXiaEd28ZSrOCHoXsuUfMk6n8k1GpDWeaMa4Ky635f1p2QoKHv8Vw=
X-Received: by 2002:a05:622a:8389:b0:4a9:b6e1:15a with SMTP id
 d75a77b69052e-4ae5adc307cmr26501cf.24.1753109741967; Mon, 21 Jul 2025
 07:55:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com> <20250717162731.446579-4-tabba@google.com>
 <ffb23653-058a-426e-9571-51784a77ad3d@intel.com>
In-Reply-To: <ffb23653-058a-426e-9571-51784a77ad3d@intel.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 21 Jul 2025 15:55:05 +0100
X-Gm-Features: Ac12FXxjOmMLuWpZC_TS5imBaYfBYtso3IHhWRxC85v1TVvpzPnUuCfabMiBMwM
Message-ID: <CA+EHjTz3Fq99q0cbkEK9KKzpSUBGfmnn_fTrQ1cOuUAQDz7=ng@mail.gmail.com>
Subject: Re: [PATCH v15 03/21] KVM: Introduce kvm_arch_supports_gmem()
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, seanjc@google.com, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
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
Content-Type: text/plain; charset="UTF-8"

On Fri, 18 Jul 2025 at 02:43, Xiaoyao Li <xiaoyao.li@intel.com> wrote:
>
> On 7/18/2025 12:27 AM, Fuad Tabba wrote:
> > -/* SMM is currently unsupported for guests with private memory. */
> > +/* SMM is currently unsupported for guests with guest_memfd private memory. */
> >   # define kvm_arch_nr_memslot_as_ids(kvm) (kvm_arch_has_private_mem(kvm) ? 1 : 2)
>
> As I commented in the v14, please don't change the comment.
>
> It is checking kvm_arch_has_private_mem(), *not*
> kvm_arch_supports_gmem(). So why bother mentioning guest_memfd here?

Ack.

Thanks,
/fuad

>
