Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795109251;
	b=H4mIE3Q4yKXRzqZA/YQN62IkY23cLY9enxKK4SFJMQW1Tvr5LongfDFS4z43UaIJJT1V
	 7pzThzJBVkkJ6zjgQUkXBWEOBx0vQCPXZpUDsNXi+bcmLrchVmk9g6AE32QywNwgYcw4H
	 CWGXnAq9/QP2ptYUg976wUn2stYgB/8y6dSjHh/14g/bd7xbdmsXsUopa3RD06frtoNv0
	 ia7hc9UqWHtAB+YhB4FtRm4088OIEmc/j5v9DEOEN9nkzscME0j7zTthevkDzl3PgVcht
	 Y1HDK5YZWhI5LNrKjD3AzgZg2Mc7zb8w+WI+yI03ON6E1lzHLifSq/OqpX5ThSrl9ZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795109251;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding;
	bh=X4SOofTg3P4HcDJklRTSxQB79GV9lxE4EdfhoGf5GQY=;
	b=pRdngPfxGw2seu+jDZwqWRmUiK8d8Q1LfJaecW+FVqWWMD7yI6u2djEdyYrI9aeRAOzL
	 KmW1mHkBJDa2Ddtg4IdjBNR/8bAngwYPmXPDOjA2yTFHYrOJ80WrS/Osy67orqJDXljhs
	 vxeBOTZlBJtJi6kK5m89fCpJR7HKtrdHBw6PRmXytQ8UCWKG4LTLiov0jTwFBSYjmjHrr
	 pIGDfGuFV9HI8ytIrxrgVXuKHdfoDEaxh+LsYCbjrBmfhvs7ZU4ytWz48/GASp4OOjyvd
	 w8ZyAaDTbjPfgby7GF4GmmtHtBpxKG7yk5eaKgfhxV8QsWTNQoUvogs1Qx15KkyAzDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=kFWwkfGA;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48F6F606A326
	for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 17:27:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 48F6F606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=kFWwkfGA
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 97BE41575;
	Thu, 19 Nov 2026 09:27:26 -0800 (PST)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F067F3F673;
	Thu, 19 Nov 2026 09:27:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795109249; bh=CdtwkWATegHb2n3avpl2PIBYTzMIZ4bsivwu55aszPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kFWwkfGAVALkjXiZ22vYEsGpOYDbKAuqy+j98LGY/CRXZyLKQjo5idlx3UsOglAdR
	 9Iic99UDpCmtD23qKvRVI+M5b5N2ZDDXBFuyd52Cxy7BXkVQZOIRahG7w8oFifVtKw
	 s/IPattHzOPqwEERG59dBvf3c9gmzg25xwKVUSPA=
From: Leonardo Bras <leo.bras@arm.com>
To: Tian Zheng <zhengtian10@huawei.com>
Cc: Leonardo Bras <leo.bras@arm.com>,
	maz@kernel.org,
	oupton@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	corbet@lwn.net,
	pbonzini@redhat.com,
	yuzenghui@huawei.com,
	wangzhou1@hisilicon.com,
	yangjinqian1@huawei.com,
	caijian11@h-partners.com,
	liuyonglong@huawei.com,
	tangchengchang@huawei.com,
	yezhenyu2@huawei.com,
	yubihong@huawei.com,
	linuxarm@huawei.com,
	joey.gouly@arm.com,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	fuad.tabba@linux.dev,
	mark.rutland@arm.com,
	seanjc@google.com,
	rdunlap@infradead.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	skhan@linuxfoundation.org
Subject: Re: [PATCH v5 06/15] KVM: arm64: Add support for FEAT_HDBSS
Date: Thu, 19 Nov 2026 17:27:10 +0000
Message-ID: <av8xblyy3GzgbNwf@LeoBrasDK>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <ceb91298-3d05-486e-a900-1291963dde24@huawei.com>
References: <20260929103655.85107-1-zhengtian10@huawei.com> <20260929103655.85107-7-zhengtian10@huawei.com> <at-X_hFbsBU_Dsgr@LeoBrasDK> <a301e884-f6d1-4082-8551-8d8a17276dc3@huawei.com> <auSml6yTVYIQe7NZ@LeoBrasDK> <ceb91298-3d05-486e-a900-1291963dde24@huawei.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Thu, Nov 19, 2026 at 03:52:37PM +0800, Tian Zheng wrote:
> 
> 
> On 10/30/2026 10:15 PM, Leonardo Bras wrote:
> > On Fri, Oct 30, 2026 at 10:53:57AM +0800, Tian Zheng wrote:
> > > 
> > > 
> > > On 10/27/2026 2:12 AM, Leonardo Bras wrote:
> > > > On Tue, Sep 29, 2026 at 06:36:46PM +0800, Tian Zheng wrote:
> > > > > diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> > > > > index 32102c3912fa..12fa37328dd2 100644
> > > > > --- a/arch/arm64/kernel/cpufeature.c
> > > > > +++ b/arch/arm64/kernel/cpufeature.c
> > > > > @@ -2158,6 +2158,11 @@ static bool hvhe_possible(const struct arm64_cpu_capabilities *entry,
> > > > >    	return arm64_test_sw_feature_override(ARM64_SW_FEATURE_OVERRIDE_HVHE);
> > > > >    }
> > > > > 
> > > > > +static bool has_vhe_hdbss(const struct arm64_cpu_capabilities *entry, int scope)
> > > > > +{
> > > > > +	return is_kernel_in_hyp_mode() && has_cpuid_feature(entry, scope);
> > > > > +}
> > > > > +
> > > > 
> > > 
> > > Hi leo,
> > > 
> > > > IIUC you run this on every cpu in the system, to make sure it's matching
> > > > the feature. Is there any chance the kernel is in EL2 only on some of the
> > > > cpus here?
> > > > 
> > > 
> > > It's impossible for the system to have only some CPUs in EL2 and others
> > >   not.
> > > 
> > > > If not, maybe we can run it on system_supports_hdbss() instead, which would
> > > > be easier for the user to understand it only runs in EL2, on top of not
> > > > needing the above.
> > > > 
> > > 
> > > However, The question is whether a cap should mean "this system can use
> > > the feature" or "this hardware supports the feature". If the cap only
> > > tracks hardware support, users may be confused when the hardware
> > > supports HDBSS but the system runs in nVHE mode — they would mistakenly
> > > believe they can use the feature.
> > > 
> > > So I think we should keep is_kernel_in_hyp_mode() in has_vhe_hdbss(),
> > > and add a comment in system_supports_hdbss() explaining this.
> > > 
> > > Does that work for you? Looking forward to your reply.
> > 
> > Well,
> > That's just my personal view of this:
> > 
> > If we have a function called "has_hdbss" it should only report if the
> > system has the feature available.
> > 
> > On the "system_supports_*" we have to figure out if the system itself
> > supports the feature, which checks the feature bits itself and could mean
> > checking for other features being there, such as hyp_mode.
> > 
> > What do you think?
> > 
> > Thx,
> > Leo
> 
> Hi Leo,

Hi Tian,
 
> Sorry for the slow reply. I've been looking into how other cpufeatures
> are configured on arm64, on and off, and that's why it took a while.

I took some time to study it as well, and to be clear, my previous 
understanding of this was incorrect, and it looks like the has_vhe_hdbss 
(.matches callback) is only called once during boot, and once per hot-added 
cpu.
 
> My reading is that detected: HDBSS should mean "this system can use
> HDBSS", not just "the silicon has it".
> 
> Several caps already add conditions beyond the ID bits. CNP returns
> false for kdump and under ARM64_WORKAROUND_DISABLE_CNP, NV and pKVM
> match on kvm_get_mode(), and can_trap_icv_dir_el1() starts with
> is_hyp_mode_available(). So in practice a SYSTEM_FEATURE cap answers
> "can this kernel use it on this system".

Humm, or maybe "can this kernel, booted as it is, use it on this system"...
 
> HDBSS is EL2-only (HDBSSBR_EL2/HDBSSPROD_EL2, VTCR_EL2.HDBSS),
> implemented only under hyp/vhe, and used only by KVM, so "the hardware
> is there" is not the same as "this kernel can use it". That is why I'd
> keep the gate in has_vhe_hdbss() rather than moving it to the consumer.
> 
> I'd be interested to hear how you see it.

I agree, that looks better this way.

I don't think I understand enough of what 'system' means in 
system_supports_*(), but I think your version explains it enough based on 
other similar functions.

Thanks!
Leo






