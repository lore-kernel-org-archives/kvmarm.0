Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FCDE481FB7;
	Fri,  2 Oct 2026 11:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790939032; cv=none; b=E5E2r6lBBwEZSh64eQlwyPM53wX8GPBEXaF6N8mxbhqfxrDb8TDhlL3qTsyukF0TWFkbVYrXVtF0Xt+eVTQds2xw9nUO5mUL5vU4eajftJuayX8PPXueJv2wwLisyzuqJXQR/jQG8u8k6ofFom2n6uDz3n9VOuapm7InS29iMKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790939032; c=relaxed/simple;
	bh=VveSnYZ4hUEZzYAVLJFm+ZlfCp0ty6xGzWYSlkf7ChU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n62vKzeeCM6To/WgbJTIjEf3Mdieo8p/902nG4HlnBfN67PjEgUqMwUlnNJijdknAcOBrJ+HfgfvRYaVE4CUoD5A8aHCx2CBXC/9pY0zy5x/RAySzLTaIE6ciuyH1RA75rq/tK7Qkn8g+e2QRBw8BfeiaOnrfYheRjsccuTk9sE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=YmhfkI/O; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="YmhfkI/O"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 39B252F;
	Fri,  2 Oct 2026 04:03:40 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A0CB53F85F;
	Fri,  2 Oct 2026 04:03:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790939023; bh=VveSnYZ4hUEZzYAVLJFm+ZlfCp0ty6xGzWYSlkf7ChU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YmhfkI/OD1wsPm44zabAN/XnWKsLo3drst6w219fnFnqdStfI9eJktiQ+vqKKoaSY
	 oL42VlAgSxTo1LXxKgePhnKaFOxVVE7H2cQmdENnHIxOmISojXwENs6+QxLhtbKNe4
	 XzxruEpHJUV6zbvvNBGAfCJIVBhCJmGs6P+7CS1I=
Date: Fri, 2 Oct 2026 12:03:36 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
	will@kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
	aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
	joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
	linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
	sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
	WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com,
	sudeep.holla@arm.com, jonathan.cameron@oss.qualcomm.com,
	Len Brown <lenb@kernel.org>, Pavel Machek <pavel@kernel.org>,
	linux-pm@vger.kernel.org, Sudeep Holla <sudeep.holla@kernel.org>
Subject: Re: [PATCH v22 07/10] kernel: hibernate: Add an arch hook for
 preventing hiberation
Message-ID: <ar-PiBQGye4_hQa6@arm.com>
References: <20261002061507.1600269-1-suzuki.poulose@arm.com>
 <20261002061507.1600269-8-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261002061507.1600269-8-suzuki.poulose@arm.com>

On Fri, Oct 02, 2026 at 07:15:03AM +0100, Suzuki K Poulose wrote:
> Add a hook to allow arch code disable hibernation. On arm64, with an RMM active,
> there could be pages that are delegated to the "Realm" security state. Any
> access to them are fatal (e.g., hibernate save image or restoring an image to
> a delegated page). pKVM host also has its restrictions on enabling hibernation.
> 
> Add a weak arch hook to let the architectures have a say.
> 
> Cc: "Rafael J. Wysocki" <rafael@kernel.org>
> Cc: Len Brown <lenb@kernel.org>
> Cc: Pavel Machek <pavel@kernel.org>
> Cc: linux-pm@vger.kernel.org
> Cc: Sudeep Holla <sudeep.holla@kernel.org>
> Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>

Nit: the subject prefix for kernel/power/ usually is

	PM: hibernate: ....

I can fix it locally, no need to respin (and probably the wrap the long
lines in the commit log, we tend to keep them shorter).

> ---
>  include/linux/suspend.h  | 1 +
>  kernel/power/hibernate.c | 8 +++++++-
>  2 files changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/suspend.h b/include/linux/suspend.h
> index b02876f1ae38a..a3815027773c5 100644
> --- a/include/linux/suspend.h
> +++ b/include/linux/suspend.h
> @@ -401,6 +401,7 @@ int hibernate_quiet_exec(int (*func)(void *data), void *data);
>  int hibernate_resume_nonboot_cpu_disable(void);
>  int arch_hibernation_header_save(void *addr, unsigned int max_size);
>  int arch_hibernation_header_restore(void *addr);
> +bool arch_hibernation_available(void);
>  
>  #else /* CONFIG_HIBERNATION */
>  static inline void register_nosave_region(unsigned long b, unsigned long e) {}
> diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
> index d2479c69d71a4..9d9d53828542f 100644
> --- a/kernel/power/hibernate.c
> +++ b/kernel/power/hibernate.c
> @@ -106,11 +106,17 @@ bool hibernation_in_progress(void)
>  	return !atomic_read(&hibernate_atomic);
>  }
>  
> +__weak bool arch_hibernation_available(void)
> +{
> +	return true;
> +}
> +
>  bool hibernation_available(void)
>  {
>  	return nohibernate == 0 &&
>  		!security_locked_down(LOCKDOWN_HIBERNATION) &&
> -		!secretmem_active() && !cxl_mem_active();
> +		!secretmem_active() && !cxl_mem_active() &&
> +		arch_hibernation_available();

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

Raphael, any objection to this patch going in through the arm64 tree? It
matches the style of other __weak functions in this file.

Thanks.

-- 
Catalin
