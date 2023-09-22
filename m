Received: from out-209.mta0.migadu.com (out-209.mta0.migadu.com [91.218.175.209])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 705CF4176D
	for <kvmarm@lists.linux.dev>; Fri, 22 Sep 2023 16:59:16 +0000 (UTC)
Date: Fri, 22 Sep 2023 16:59:08 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1695401954;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=y6/hQEMPVHQkW+VGeoG3f+C/qAx++wI6UHGjk2uuU5Q=;
	b=PKtkMDQtsJGBrPV3WbBf4dphx8J+NtrxPNNLjB6ssrYvNm6jqVgfH/aiga5EoTAXARCkWU
	8N2mYGpI8ms+vfz5Sw349w/Fe85OH20Qy8UdurnX8iOd9YD7Czm3pBbpIYFFEaqHakIQzd
	jAEIhbt4CP2AZuvrHMlsXMwZcmggyOs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, maz@kernel.org,
	will@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, zhukeqian1@huawei.com,
	jonathan.cameron@huawei.com, linuxarm@huawei.com
Subject: Re: [RFC PATCH v2 6/8] KVM: arm64: Only write protect selected PTE
Message-ID: <ZQ3H3JZHnxIVCIF6@linux.dev>
References: <20230825093528.1637-1-shameerali.kolothum.thodi@huawei.com>
 <20230825093528.1637-7-shameerali.kolothum.thodi@huawei.com>
 <ZQ26KE2bzEFYUpMc@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZQ26KE2bzEFYUpMc@arm.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Sep 22, 2023 at 05:00:40PM +0100, Catalin Marinas wrote:
> On Fri, Aug 25, 2023 at 10:35:26AM +0100, Shameer Kolothum wrote:
> > From: Keqian Zhu <zhukeqian1@huawei.com>
> > 
> > This function write protects all PTEs between the ffs and fls of mask.
> > There may be unset bits between this range. It works well under pure
> > software dirty log, as software dirty log is not working during this
> > process.
> > 
> > But it will unexpectly clear dirty status of PTE when hardware dirty
> > log is enabled. So change it to only write protect selected PTE.
> 
> Ah, I did wonder about losing the dirty status. The equivalent to S1
> would be for kvm_pgtable_stage2_wrprotect() to set a software dirty bit.
> 
> I'm only superficially familiar with how KVM does dirty tracking for
> live migration. Does it need to first write-protect the pages and
> disable DBM? Is DBM re-enabled later? Or does stage2_wp_range() with
> your patches leave the DBM on? If the latter, the 'wp' aspect is a bit
> confusing since DBM basically means writeable (and maybe clean). So
> better to have something like stage2_clean_range().

KVM has never enabled DBM and we solely rely on write-protection faults
for dirty tracking. IOW, we do not have a writable-clean state for
stage-2 PTEs (yet).

-- 
Thanks,
Oliver
