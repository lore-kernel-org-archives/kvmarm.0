Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 682421891B9
	for <kvmarm@lists.linux.dev>; Mon, 17 Jun 2024 17:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718646045; cv=none; b=EEI7Cp5CXZ3epHnLcM94JraYDlIptOYP1sdrntQhYtZHbrDAlaFTH9TZ0VvtBzyaMw/4CuQDuXveQtCSb8o5bZOvNPaLyXPrbpUYQwhYP12Ibr/LIpvVeAgIeufR5WU1HPP4Yo4hdb74WkslVVEm1FsbBs8O79dXzgpdTweVIHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718646045; c=relaxed/simple;
	bh=O44bg5IN3bpweFi97y7tt8VcamC1B+cu2qGxErr7ez8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WtAF1CNPZgJkPkcm6J0Q4uJdSUFX25m79S8c5w5KWNeOl+9HKFWpikKJGbrHIDysu+suMukprLrs6O4O190Bq1TSYoGF0t+cO9oGIhkatVMdJnPST9dXvcgYCqTuyR/095a6GHRqX0MiDu10C/+OQKhwxnl3UULHjzTlYN1pMM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZZS2E4bo; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZZS2E4bo"
X-Envelope-To: shahuang@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718646042;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=okv/SBVT+t/mscY2NbGXxvwNhjZy/ckRAi7DnSHOqKA=;
	b=ZZS2E4bouTntLdhRdKDBwzqHEL50a8ctu3G8V36RUt1ypOp+M+UED4Hve02PlfU857ISH9
	+2z7zqvoPPesAU+CJb5hrVqJLOOec7PeOFz2fNoIuEuztzqoQCLxUP8QmVYYZegmLfJLQS
	qSyw/Mt5PuufQBHEqPeIIYO+5J3HuoU=
X-Envelope-To: maz@kernel.org
X-Envelope-To: kvmarm@lists.linux.dev
X-Envelope-To: catalin.marinas@arm.com
X-Envelope-To: james.morse@arm.com
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: linux-arm-kernel@lists.infradead.org
X-Envelope-To: linux-kernel@vger.kernel.org
X-Envelope-To: linux-kselftest@vger.kernel.org
X-Envelope-To: pbonzini@redhat.com
X-Envelope-To: shuah@kernel.org
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: will@kernel.org
X-Envelope-To: yuzenghui@huawei.com
Date: Mon, 17 Jun 2024 17:40:36 +0000
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Shaoqin Huang <shahuang@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	James Morse <james.morse@arm.com>, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Will Deacon <will@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v1 0/2] KVM: arm64: Making BT Field in ID_AA64PFR1_EL1
 writable
Message-ID: <ZnB1FPw3Eg8-61mL@linux.dev>
References: <20240617075131.1006173-1-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240617075131.1006173-1-shahuang@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Jun 17, 2024 at 03:51:29AM -0400, Shaoqin Huang wrote:
> In this patch series, we try to make more register fields writable like
> ID_AA64PFR1_EL1.BT since this can benifit the migration between some of the
> machines which have different BT values.
> 
> Changelog:
> ----------
> RFCv1 -> v1:
>   * Fix the compilation error.
>   * Delete the machine specific information and make the description more
>     generable.

Can you please address Marc's feedback?

If we only make things writable a field at a time it's going to take
forever to catch up w/ the architecture.

https://lore.kernel.org/kvmarm/86zfrpjkt6.wl-maz@kernel.org/

-- 
Thanks,
Oliver
