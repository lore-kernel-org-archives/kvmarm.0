Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02714BA52
	for <kvmarm@lists.linux.dev>; Tue,  4 Apr 2023 16:00:47 +0000 (UTC)
Received: by mail-wr1-f52.google.com with SMTP id r11so33333630wrr.12
        for <kvmarm@lists.linux.dev>; Tue, 04 Apr 2023 09:00:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680624046;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8K2SCp3N7WmXl5Hlded+U+tmuHCBjMjb7rjTKVn+ghk=;
        b=owhdeMQ665T618BPk+i/t5+b22DfkXcK5JP+rpAZdWk3KRCpsDtTpmaa4HT2RDnqld
         PYlRYjyf9wkXrjdfIHzBk2Act08sGj8PBm7Wg3vHTx63pYbuU/xX7cD93j3TEYQj7ACc
         PZ3+p6b+w5kELe6CyS0//j7RztJLt1C++sv2wDPybtRZx3tZSypUE0ELXrb9KqVq+jC6
         2MNYVUifpj6TYfpnAK7lQuBAIIKUvur44LiyBtIYM3Tw7+1rTkMWb1AEZNgg/McpK/MV
         Sq91mzgjuwiCSvVO3pzdmrNE8j5CQ8zT4lLXpt5FP8nSeYw7i1lgExkxbw75QZ3ggIAP
         eN1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680624046;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8K2SCp3N7WmXl5Hlded+U+tmuHCBjMjb7rjTKVn+ghk=;
        b=3UOGFzrvDdsEFBGRmPfMP3Y7f11BDrMuRTg6VRwZdK2cl5saOujdVAduow/9VOMTV4
         GEhveoI0xVxVVDhzphjM8lkg/y/BsEkixFjX6n4lvwtTzHFDHbE+LkX1uxSOtjse6Nk1
         2VIXKZNsGMcVQ/wHaVqvRKEO+EVns8jIkqb7dnst7hR2yajEPVu4J5eILCZo0N5TOBhO
         QfH9Xaf1dOWcb5tC30bD49oLvH5BFvx6kuzNGgaEpN5Y4k5KzgnrH2En/RSBP/TFMItd
         swFkbRN5qV91oFRLO9MDdyrFyTE/pDGu5t3qWn3cYuXJuPXGzvRY+NxKRXZChQN9VcBF
         JuXg==
X-Gm-Message-State: AAQBX9dEHek6vYjg2yLwEk2dhfYhsJv56OAIpnIABM5Y+wWDRDfmXu2u
	YR8Xw1c4wgZL1BwBMmXoCB1IEg==
X-Google-Smtp-Source: AKy350Yhk5Yty0BVntaEj2IuKQU6pcpCE8rOGmBm4/2Og/8fIk8LVzOTYonEUbAff04/787UgUetIQ==
X-Received: by 2002:a5d:4b91:0:b0:2e5:31a3:38d4 with SMTP id b17-20020a5d4b91000000b002e531a338d4mr1916594wrt.55.1680624046051;
        Tue, 04 Apr 2023 09:00:46 -0700 (PDT)
Received: from myrica (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id n9-20020a5d4009000000b002d431f61b18sm12480440wrp.103.2023.04.04.09.00.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 09:00:45 -0700 (PDT)
Date: Tue, 4 Apr 2023 17:00:46 +0100
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: Mostafa Saleh <smostafa@google.com>
Cc: maz@kernel.org, catalin.marinas@arm.com, will@kernel.org,
	joro@8bytes.org, robin.murphy@arm.com, james.morse@arm.com,
	suzuki.poulose@arm.com, oliver.upton@linux.dev,
	yuzenghui@huawei.com, dbrazdil@google.com, ryan.roberts@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	iommu@lists.linux.dev
Subject: Re: [RFC PATCH 20/45] KVM: arm64: iommu: Add map() and unmap()
 operations
Message-ID: <20230404160046.GA305012@myrica>
References: <20230201125328.2186498-1-jean-philippe@linaro.org>
 <20230201125328.2186498-21-jean-philippe@linaro.org>
 <ZCXRbF0dP7oHT+hl@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZCXRbF0dP7oHT+hl@google.com>

Hi Mostafa,

On Thu, Mar 30, 2023 at 06:14:04PM +0000, Mostafa Saleh wrote:
> > +err_unmap:
> > +	__kvm_iommu_unmap_pages(&iopt, iova_orig, pgsize, pgcount_orig - pgcount);
> On error here, this unmaps (and unshares) only pages that has been
> mapped.
> But all pages where shared with IOMMU before (via
> __pkvm_host_share_dma) and this corrupts the other pages state as
> they are marked as shared while they are not.

Right, I'll fix this

> I see we can add a "bool unshare" arg to __kvm_iommu_unmap_pages which
> will be called with false on error from here after calling
> __pkvm_host_unshare_dma for the whole range.

I think it's simpler to call iopt_unmap_pages() directly here, followed by
__pkvm_host_unshare_dma(). It even saves us a few lines

Thanks,
Jean

