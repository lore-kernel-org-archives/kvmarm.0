Received: from mta0.migadu.com (out-20.mta0.migadu.com [91.218.175.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7C31382F15
	for <kvmarm@lists.linux.dev>; Mon, 24 Aug 2026 18:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787595349; cv=none; b=nXIoLCWuHMoIysDYAGE7HFTxRSpRNsqTVMVu2lN8U1x4MnP4fw4bN74DCFs5b9ywEIH66WG9/B41H5TMh4mdh4tcMUoKl1vLV22+EPO/AYoBvlF+S98QPyo37V1Ogy7ZUAIdHWYpS6nDYXiX53xux6jC6XrW6pALjJnECcoiYVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787595349; c=relaxed/simple;
	bh=YbEiycZ2zmkIOvgdOThYOxacEg5IxP+K32goDMpZn64=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MidgDpwD93fvqAIBmbgzseUXgw9dG8sF5kG8v+kFR7qZYLC4Hqz3A1EVhE3QBJEwP69TeyTE/iQJTIgEZ2rN3OCScS4HPWKlQ7EhIbMTXQRhmrUTJk5oK1EyZHdkqCeBun/VlcRvPDt9rI7tfPWDBIjlLdjDJn1A47mmP0jIS3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tkeWAeA4; arc=none smtp.client-ip=91.218.175.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tkeWAeA4"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=YbEiycZ2zmkIOvgdOThYOxacEg5IxP+K32goDMpZn64=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787595343; v=1; x=1788200143;
 b=tkeWAeA4AchaaRR8S3NKY8CAbFHvnwuQpOu27Bf754S7QNNJEZxCvWqJiqoDJ6LrIM+w0D5i
 0sLa0JrLGjrGvjRqv6DeLlTd3Sm6ZK3kITApjipDE/PTvvQIrNMqScebpUrq3iFdw/iOggHWZEw
 rEDVmZ/9AHHoAm0klDGKBPdU=
X-Envelope-To: kvmarm@lists.linux.dev
Received: from mail-lf1-f42.google.com (209.85.167.42)
	by smtp.migadu.com with ESMTPS id bbede19f1fcf5989;
	Mon, 24 Aug 2026 18:15:42 +0000
X-Mizu-Trace-ID: bbede19f1fcf5989
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5b2a73da7e1so1129e87.0
        for <kvmarm@lists.linux.dev>; Mon, 24 Aug 2026 11:15:42 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rq58DnXzcjzESspsZI7+8XPY/zZ98c7Lg6XsQ5fWHcga78RzT8WgKhW0Ug47Hr2/vG/sG/psU8=@lists.linux.dev
X-Gm-Message-State: AFuF++nFef84w1bR08RnpPD7rWCyY6E9Mbgqb3O7zWidCSQ59cC/SKtf
	+LkTH+seLNjLJH6835kme3ZXxmVVGYrYpqCXVvc9MUPLv1HbCtsi02JCVb5QSGT5UaYvvJyOXEG
	ho+8oYLYuw/FwpnTivZzTR+V3KDe9MLoNkdvmhj1W
X-Received: by 2002:a05:6512:68c:b0:5b2:a5e9:3aba with SMTP id
 2adb3069b0e04-5b49cf97240mr2500e87.6.1787595341656; Mon, 24 Aug 2026 11:15:41
 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260731143541.956291-1-vdonnefort@google.com>
 <20260731143541.956291-10-vdonnefort@google.com> <CA+EHjTy7SUFsE3N5ERV_FQw-3GyEo17mqe2=RbV1wz8bVT+JXw@mail.gmail.com>
 <aoxwAukYucNw1T2p@google.com>
In-Reply-To: <aoxwAukYucNw1T2p@google.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 24 Aug 2026 19:15:05 +0100
X-Gmail-Original-Message-ID: <CA+EHjTwp=80sZar7XXd1ojZKpTooDeCK-td8q2L7qgVzayFjmw@mail.gmail.com>
X-Gm-Features: AcwNN1VVUW-WOS6MtAzeV_MzbZbW3Qcn1JrVjDOrdzhSnT5drlzH82qf83dJDv4
Message-ID: <CA+EHjTwp=80sZar7XXd1ojZKpTooDeCK-td8q2L7qgVzayFjmw@mail.gmail.com>
Subject: Re: [PATCH v4 09/17] KVM: arm64: Add selftests for the pKVM heap allocator
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com, 
	qperret@google.com
Content-Type: text/plain; charset="UTF-8"

On Mon, 24 Aug 2026 at 17:23, Vincent Donnefort <vdonnefort@google.com> wrote:
...
> Clearly not something that would happen but I can put the #ifdef inside
> handle___pkvm_hyp_alloc_selftest() so it looks cleaner:
>
>   static void handle___pkvm_hyp_alloc_selftest(struct kvm_cpu_context *host_ctxt)
>   {
>           struct pkvm_hyp_req req = { .type = PKVM_HYP_NO_REQ };
>           int ret = -EPERM;
>
>   #ifdef CONFIG_NVHE_EL2_DEBUG
>           ret = hyp_allocator_selftest();
>           if (ret == -ENOMEM) {
>                   req.type = PKVM_HYP_REQ_HYP_ALLOC_SELFTEST;
>                   req.mem.nr_pages = hyp_alloc_selftest_topup_needed();
>           }
>   #endif
>           cpu_reg(host_ctxt, 1) = ret;
>           pkvm_hyp_req_to_smccc(host_ctxt, &req);
>   }
>
> Regarding pkvm_call_hyp_req(), how about a proper kerneldoc?
>
>  /**
>   * pkvm_call_hyp_req() - Issue an HVC that can return hypervisor requests
>   * @f: Hypervisor function symbol to call.
>   * @...: Arguments to pass to the hypercall.
>   *
>   * Re-issue an HVC and process any pending hypervisor request until completion
>   * or error.
>   *
>   * Only use this helper for HVCs whose hypervisor handlers format their return
>   * registers with pkvm_hyp_req_to_smccc().
>   *
>   * Return: Result of the hypercall or a negative error if the hyp request
>   * handling failed.
>   */

Both look good. The merged handler writes x2 through the no-req path,
which is what I was after, and the kerneldoc states the rule.

Thanks,
/fuad

>
> --
> Vincent
>
