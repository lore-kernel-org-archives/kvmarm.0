Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D7902C1593
	for <kvmarm@lists.linux.dev>; Thu,  4 Sep 2025 08:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756974671; cv=none; b=qLzz1AIpwwe2X/e+6iiHRQxPlRDx4oLG+B5q5qozhmxCA9MBsuAR/sZ0fNmsP5pDfNWcxFWKico8icP/5mdWimhkYMSHt61eEvd/Oya6soxpZtfnaSEEWs0pPDEoVoMxY9E+pJKB2Y9a/ZIUiFhAJ5Edt65xfT0PuJohekVtnLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756974671; c=relaxed/simple;
	bh=dNK+Uh0eSrcb1kz54j/HC6iHQyjm3cyL0Ws0tPsoLEk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NpN5SjJzg2dso9YCNB8WPdAlPYKWB4UIpSL9771ejxHCnr/Wr1w+cLD8BKHuRRC7ysz6x6IhMH+S5Q6UzYGzRECeFJLEz7SZNllStake2g4keh3rt64qhCTmowSsnCpwDxReBvPs/al6qCSpp/4GiywCpGkXMiG4q4C68LSfO7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xZZHEQPI; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xZZHEQPI"
Date: Thu, 4 Sep 2025 00:26:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1756974655;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oNdZCLI9Qh4c9oJ4l0QFxSHO1I3wLPIs2ZcoTVbvVSI=;
	b=xZZHEQPICy+oxcy5y2oGaGUIUdwzJ0QpB0CjVdocLgXh97ZBpxbOzHhYQ366AXqVNLIVYS
	Uc48K+mfCygSr09+VVL+rHrFbxEYnSq1LyKoavn7mwraT6POlwjhCXOeeKT46YDUl7fHJL
	YgdMjHHiu85UjKVXDkQIH/KuLMsce24=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Yingchao Deng <yingchao.deng@oss.qualcomm.com>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, James Clark <james.clark@linaro.org>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, quic_yingdeng@quicinc.com,
	jinlong.mao@oss.qualcomm.com, tingwei.zhang@oss.qualcomm.com
Subject: Re: [PATCH v2] KVM: arm64: Fix NULL pointer access issue
Message-ID: <aLk_F8LgpFW6Qo3O@linux.dev>
References: <20250902-etm_crash-v2-1-aa9713a7306b@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250902-etm_crash-v2-1-aa9713a7306b@oss.qualcomm.com>
X-Migadu-Flow: FLOW_OUT

Hi Yingchao,

The shortlog is extremely vague, you should aim to succinctly describe
the functional change of your patch. e.g.

  KVM: arm64: Return early from trace helpers when KVM isn't available

On Tue, Sep 02, 2025 at 11:48:25AM +0800, Yingchao Deng wrote:
> When linux is booted in EL1, macro "host_data_ptr()" is a wrapper that
> resolves to "&per_cpu_ptr_nvhe_sym(kvm_host_data, cpu)",
> is_hyp_mode_available() return false during kvm_arm_init, the per-CPU base
> pointer __kvm_nvhe_kvm_arm_hyp_percpu_base[cpu] remains uninitialized.
> Consequently, any access via per_cpu_ptr_nvhe_sym(kvm_host_data, cpu)
> will result in a NULL pointer.
> 
> Add is_kvm_arm_initialised() condition check to ensure that kvm_arm_init
> completes all necessary initialization steps, including init_hyp_mode.

OTOH, the changelog is very mechanical and hard to grok.

  When linux is booted at EL1, host_data_ptr() resolves to the nVHE
  hypervisor's copy of host data. When hyp mode isn't available for
  KVM the nVHE percpu bases remain uninitialized. Consequently, any usage
  of host_data_ptr() will result in a NULL dereference which has been
  observed in KVM's trace filtering helpers.

  Add an early return to the trace filtering helpers if KVM isn't
  initialized, avoiding the NULL dereference.

> Fixes: 054b88391bbe2 ("KVM: arm64: Support trace filtering for guests")
> Signed-off-by: Yingchao Deng <yingchao.deng@oss.qualcomm.com>
> Reviewed-by: James Clark <james.clark@linaro.org>
> ---
> Add a check to prevent accessing uninitialized per-CPU data.
> ---
> Changes in v2:
> 1. Move the warning to the end in order to improve readability. No
> functional change intended

IMO, the warning should be the very first condition we evaluate. Even if
the system configuration leads to an early return anyway (e.g. protected
mode) the caller is not invoking these helpers from the right context.

Thanks,
Oliver
