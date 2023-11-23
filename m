Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA2352136F
	for <kvmarm@lists.linux.dev>; Thu, 23 Nov 2023 09:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dMc5Ar87"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-548c6efc020so9547a12.0
        for <kvmarm@lists.linux.dev>; Thu, 23 Nov 2023 01:49:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1700732962; x=1701337762; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=53mgz2I67bBPUMmao+k8i5+WtnPQJvvF0nHCuvFZ/vw=;
        b=dMc5Ar87+j4RtgKfyCa0nXco097hKIr15c2hEA+i3fCPGcTDMfPYVKGwtVn1GHTSVr
         zekmva/vL3Lbqk/mKlRM5oJylDpl/MoK7HjHDCfsxQpe7tyNFaVDX2TWlM2TI/juxZkL
         Zwt1juxt8co8R0HciBgaGloKNvmZgCuZi56ajba99YEBjCqO9GKIuu7D0csVG1jxe6Tb
         2H1sLohAgLYWUpOnxtZZC4PCmFCupzxGfsDcdhdiBrzQbhOe6Uuyir7bushgjnOaxog/
         50gMJ1ZRGjFztt3/7U/OG+DDQK2cS1e9Hm7PL5sOrJJ8lTbwwWuix2+zf/6pW+JDM720
         LSOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700732962; x=1701337762;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=53mgz2I67bBPUMmao+k8i5+WtnPQJvvF0nHCuvFZ/vw=;
        b=AzLrCrH/YGLTUCPfK7fywz8LPz+eW6FDqat4TfxCUAGMx8g0gPpPPJKCY+fYYDxOHr
         GxPP1i/UOitsd9ZYxpkfc303Gmt+PjOE4/tzFAaO+nwMwCPoKGfXdsI040DerJY71Zxv
         qeV9RmluNEczsaaI35fI2EsziYLMVSxOmxkouGGERTpyUemxqPSWEeupZnlEe9IWBMoN
         y0D+UjWrpZKT0ZSz45Gwg15WRxQfyJOCACB0GzZAT1BJzaOquXO9j5NCfVhURAz/yzed
         2h5RfhGuOAGPoSZu+ihS34q3GblwS4nkpgdqC2Um4B5PiGkMshX1Oblude3hlQcLXT88
         OB9Q==
X-Gm-Message-State: AOJu0YyoiTxUYMBCqWVkLFsH33r6Nn+zxaMIHAPk8LPVaARKpYvgaaAy
	pTOvHFYXvvtbDG7J0JrNpet6lw==
X-Google-Smtp-Source: AGHT+IGcKXGwNmDsBQqKA/iG8b0gT6CgYkVFrfoOHPHcaUQILJhKYcBEUn/xAg67qiro7eA/qQPVkA==
X-Received: by 2002:a05:6402:3815:b0:544:466b:3b20 with SMTP id es21-20020a056402381500b00544466b3b20mr242943edb.5.1700732961713;
        Thu, 23 Nov 2023 01:49:21 -0800 (PST)
Received: from google.com (110.121.148.146.bc.googleusercontent.com. [146.148.121.110])
        by smtp.gmail.com with ESMTPSA id k24-20020a5d5258000000b00332c0aace23sm1162986wrc.105.2023.11.23.01.49.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Nov 2023 01:49:20 -0800 (PST)
Date: Thu, 23 Nov 2023 09:49:17 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: will@kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, catalin.marinas@arm.com,
	mark.rutland@arm.com, akpm@linux-foundation.org, maz@kernel.org,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, kernel-team@android.com,
	vdonnefort@google.com, qperret@google.com, smostafa@google.com
Subject: Re: [PATCH v3 00/10] arm64: ptdump: View the second stage page-tables
Message-ID: <ZV8gHfnrFzhdjjw5@google.com>
References: <20231115171639.2852644-2-sebastianene@google.com>
 <ZV6MVYI8J6NFS9Wl@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZV6MVYI8J6NFS9Wl@linux.dev>

On Wed, Nov 22, 2023 at 11:18:45PM +0000, Oliver Upton wrote:

Hi Oliver,

> Hi Seb,
> 
> On Wed, Nov 15, 2023 at 05:16:30PM +0000, Sebastian Ene wrote:
> > Hi,
> > 
> > This can be used as a debugging tool for dumping the second stage
> > page-tables.
> > 
> > When CONFIG_PTDUMP_STAGE2_DEBUGFS is enabled, ptdump registers 
> > '/sys/debug/kvm/<guest_id>/stage2_page_tables' entry with debugfs
> > upon guest creation. This allows userspace tools (eg. cat) to dump the
> > stage-2 pagetables by reading the registered file.
> > 
> > Reading the debugfs file shows stage-2 memory ranges in following format:
> > <IPA range> <size> <descriptor type> <access permissions> <mem_attributes>
> > 
> > Under pKVM configuration(kvm-arm.mode=protected) ptdump registers an entry
> > for the host stage-2 pagetables in the following path:
> > /sys/debug/kvm/host_stage2_page_tables/
> > 
> > The tool interprets the pKVM ownership annotation stored in the invalid
> > entries and dumps to the console the ownership information. To be able
> > to access the host stage-2 page-tables from the kernel, a new hypervisor
> > call was introduced which allows us to snapshot the page-tables in a host
> > provided buffer. The hypervisor call is hidden behind CONFIG_NVHE_EL2_DEBUG
> > as this should be used under debugging environment.
> 
> While I think the value of the feature you're proposing is great, I'm
> not a fan of the current shape of this series.
> 
> Reusing note_page() for the stage-2 dump is somewhat convenient, but the
> series pulls a **massive** amount of KVM details outside of KVM:
> 
>  - Open-coding the whole snapshotting interface with EL2 outside of KVM.
>    This is a complete non-starter for me; the kernel<->EL2 interface
>    needs to be owned by the EL1 portions of KVM.
> 
>  - Building page-table walkers using the KVM pgtable library outside of
>    KVM.
> 
>  - Copying (rather than directly calling) the logic responsible for
>    things like FWB and PGD concatenation.
> 
>  - Hoisting the definition of _software bits_ outside of KVM. I'm less
>    concerned about hardware bits since they have an unambiguous meaning.
> 
> I think exporting the necessary stuff from ptdump into KVM will lead to
> a much cleaner implementation.
> 

Right, I had to import a lot of definitions from KVM, especially for the
prot_bits array and for the IPA size retrieval. I think it would be less
intrusive the other way around, to pull some ptdump hooks into kvm.

> -- 
> Thanks,
> Oliver

Thanks,
Seb
