Received: from mta0.migadu.com (out-75.mta0.migadu.com [91.218.175.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BE79484894
	for <kvmarm@lists.linux.dev>; Wed,  7 Oct 2026 13:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791380794; cv=none; b=iGsxiL5ky/lkHdYziogtyCP7hQYBZLWTpEqdzVFn10ioBvdiikv1qJ9HodEO3rSOEupXwsl21+4p7i0H50JAvmEGnA7WUeBXSBt0zjBta9o2XLLr5cx4tltmDPGEW/eiwy8+//tgCot5DwcoFSiJlLc19uiCXKjH3K/Bis4b4wM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791380794; c=relaxed/simple;
	bh=EOLf8afyt5b6SOANC3rqCkf69jr4nV59FAjYhwNBzS4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rmVXV4UmuKAUlvNGUAyCvMT+4J1FF4zLEFEVdiQucyy5voTAJ3QI3UMUZcpS62YmC81N9riMltmIL/it1WmvdMl7m4zKqIK+rXQeIGAoFMdEYYrsyZV4aLlQWjDnBAbj1hTMCNf148+9C8hNTAQrq4O5vBOQWLa2Hmb4jlyTnjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NReHhLKh; arc=none smtp.client-ip=91.218.175.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NReHhLKh"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=EOLf8afyt5b6SOANC3rqCkf69jr4nV59FAjYhwNBzS4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791380784; v=1; x=1791985584;
 b=NReHhLKhFMfzXPAWTxt4xmRvOMajkIT00NLyFutFSAFABdCQoz9sVnjauO6LqIT5PKSnRHNg
 IoVcU+PDHHINi5Lmh9eD9AUtGlM8KOh0R54G1bNhKIh9BMOh/VO2zZIIHdFg32CZ4rYHPtkBm/5
 jX+akeErsmPEf/gFediUcFoY=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 37f9a3236aa2cb18;
	Wed, 07 Oct 2026 13:46:13 +0000
X-Mizu-Trace-ID: 37f9a3236aa2cb18
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5bcbb378fc9so9230e87.0
        for <kvmarm@lists.linux.dev>; Wed, 07 Oct 2026 06:46:13 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBysZJjTBM5g8orfCpZku3YXLoaSWuERSqhsQZzl7bo/5jmYz1Ekv1V+J7i5TxRrulSI2/X3AGM=@lists.linux.dev
X-Gm-Message-State: AFq9FYK7XS/+frvqAmc35NoEO0s3jejRUIA/dH5TCBzcxlw50wL9ZgLo
	EPwn6ZZHiGNGdawizVX75PomNGE7GH4VIT79ma9E187pbv5IEZ8UOhdgwasT+2lHYqg8v6fbi+/
	SNxPW7DCXbVvYaQPu7N4TmhPddFLQF7n6AKJsJq2+
X-Received: by 2002:a05:6512:a83:b0:5bc:b531:51ea with SMTP id
 2adb3069b0e04-5bcca86c249mr304368e87.13.1791380772866; Wed, 07 Oct 2026
 06:46:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261007073537.2454351-1-suzuki.poulose@arm.com> <20261007073537.2454351-14-suzuki.poulose@arm.com>
In-Reply-To: <20261007073537.2454351-14-suzuki.poulose@arm.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 7 Oct 2026 15:45:36 +0200
X-Gmail-Original-Message-ID: <CA+EHjTy_1EekD472UH=CDSpC7oksdy3eS8AP0rPxKkhQ_PyXdg@mail.gmail.com>
X-Gm-Features: AclHuK_J8GmFTVM33wX7R0VP_JP-fZesKaU03j7TLtkYQU0t9fz-B9AOXRmoM04
Message-ID: <CA+EHjTy_1EekD472UH=CDSpC7oksdy3eS8AP0rPxKkhQ_PyXdg@mail.gmail.com>
Subject: Re: [PATCH v23 13/14] KVM: arm64: Mandate VGIC v3 for pKVM VMs and Realms
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org, 
	will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, steven.price@arm.com, 
	aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com, 
	joey.gouly@arm.com, yuzenghui@huawei.com, linux-coco@lists.linux.dev, 
	gankulkarni@os.amperecomputing.com, sdonthineni@nvidia.com, 
	alpergun@google.com, fj0570is@fujitsu.com, WeiLin.Chang@arm.com, 
	lpieralisi@kernel.org, enju.kohei@fujitsu.com, sudeep.holla@arm.com, 
	jonathan.cameron@oss.qualcomm.com
Content-Type: text/plain; charset="UTF-8"

Hi Suzuki,

On Wed, 07 Oct 2026 08:35:36 +0100, Suzuki K Poulose
<suzuki.poulose@arm.com> wrote:
> pKVM does not trust the host. Realm VMs follow a similar trust model, with
> the Realm Management Monitor owning the protected state instead of the
> host. Add a helper to identify VMs that run under a host-distrusting
> hypervisor.

When I reviewed this in v21, the Realm patches that use this came
later in the same series. Without them, kvm_vm_hyp_is_distrusting() is
true exactly when is_protected_kvm_enabled() is, and protected mode
already doesn't register a GICv2, so this patch doesn't change
anything on its own. Should it move to the series that adds Realms?

Cheers,
/fuad
