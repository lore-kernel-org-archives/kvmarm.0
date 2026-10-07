Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98CB449E5FA
	for <kvmarm@lists.linux.dev>; Wed,  7 Oct 2026 11:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791371997; cv=pass; b=GO7O0NRFthVKQWZhhJDXi9s4Ifut53Cy4JZBH1EcN5C8QFIqiQAmyTvfMXnE2bFG6c+NGtBWZr/MLKg8rwgvdR2U2hAXiAc3uMoGdnnGdzADjtMyxEeJmN5mynHU1ekoBgOmunkUfEmNLHqBJWgBD/ANuuyHhxClpdEwX9eKzh8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791371997; c=relaxed/simple;
	bh=VTU69CrXg+oUNUa21qt+heVePxURpvvJ4P7YR2kHJSA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=p1jYD+DkbPipJHzGaAMRM8FOo3c+VNfbzXFoWibouMR0C83mw1DB78HW3o70xkzTr4kNJLiNKTsUJ+eeRflbxv/hDvJjKMebxMgv5Pj5RWwTz+ykmQuCqy49jF/C56G6P/S/uOX0iwU+NmzI94fNsX3oa3NXvZGdpumewFgYhMo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fnuNFLE6; arc=pass smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fnuNFLE6"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5ba429b64c5so5715e87.1
        for <kvmarm@lists.linux.dev>; Wed, 07 Oct 2026 04:19:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791371958; cv=none;
        d=google.com; s=arc-20260327;
        b=jhvoYcGC2eDD9iueyCSdXKm4b+ZVw0psdClnHvcleRV30EpgpZLeLYdPIZSuMVm8+y
         L/nnfvGiyCz5I9ifDn1DfaBXDk3Yiv10onhgkOyunEK61QzopmtD37K2oq9JbEC3Reue
         3TTc2b8zYQJwL1JPIvc65wv3InEPNJNdAKi1Jf8KvJS5EegXFSikPfXUSzhtGs+oVh/Y
         fhbGxIL+rv+NSZPcpXv+kdCRZAcodMJ1vgvi7O8ax3Fwj+DmJzh/llPv7RKGfe8iCtUe
         DW2BCaQ361Yd0Pw1k6eNus+Aoi4+ymIxPMCf6yLNpwdhYZftI1NyM+LLTffuIPAZYTcP
         uNtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=VTU69CrXg+oUNUa21qt+heVePxURpvvJ4P7YR2kHJSA=;
        fh=YsBeUVgbC9P6aARqyO/TpCcH3vPN+FASu51Y/C2r8Dg=;
        b=LvYQyTXc0/YUQowJEx/XhQJUSUrT+uhM8QL4s4XJPfiwhRpJkq9Ds6/h22e4RhlqS7
         /Stu7TceSxyFN6kHdvmUiRAgRgnrlNCpqyRsniSUj1cAv+P6mlYnBuOIMKx4vYnYDiJ3
         bd0JjuxAMpEcinjHbFjP+SGeryeo9KDXvl0Eep50KlBj14MgfGy7Avg/vILsUUBHUn3k
         sSOJyouACFEMHLNjcBggGpUn/uZ3xAKYY04jmo0VQaVJ2IqFNn7KyfJzfmiLx/AnKXUm
         7pYDRMvBVrbKqL16a7fgKqye+Rsv+WSuzQ2WinYwD6qWE4TlWg0tF7tEaHx+0+lUizsy
         gWWw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791371958; x=1791976758; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VTU69CrXg+oUNUa21qt+heVePxURpvvJ4P7YR2kHJSA=;
        b=fnuNFLE6EVVEsb2AIl6FIWy6+RnCbiZIX1wgHldkhwUnzUEdnlnS/kJvsqVBrBEMwP
         jw0+4RhnuSCtqNX663320KGww0g/ZsFBslajCcXVllcn7PUOFDfbH7nGGWgil7Sdgago
         fSn8mUVovhb8fDVYL8S13XFbN6JWDdS9ofqvFLwQOVdESN4KpB4Qko1yPqwEkOOecEZe
         PcUDZJdEKmIheQmrml2UlcEcBByPqJse4jgkO4vVlTMMkZeEshqpHM53jWES+lGNFSKv
         d3QypzrRzCjxJcQnTVPFt17pLeXcx+9dAXtjkSofyEf1VL0WpSWrcC2mhZMlcIpihehD
         Ngdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791371958; x=1791976758;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=VTU69CrXg+oUNUa21qt+heVePxURpvvJ4P7YR2kHJSA=;
        b=HkH9dS0l4HqGP4snCGZbeDzN1JtCoCeRM6i/q0dY7/5FmLz5Tfh5W3E7MGYLmpoO3F
         k+3vS6NsEn3Y7ObF3FckvQtL6R+2fYsq9jygKU6GOTj9/AWZDN/7FOrE263t9CHujRrU
         xo58LBYcYbgu07Igw52cFU3gH8sIrBies1f86cyf2j59tiGfrPDP8cDnfowWbjWCV0eh
         3D8HeJD8kCIlvsC6kM3mNUK+1+k8gXNaZiUV0muFXq4dCexzk+qriI+MfT3NVGZdpaZz
         9U1b7PWQ3ywy0hZXSfD87uwVGb0+acRZ0TdRVDonAm2f0UvkRnIym1cz7sXl6CvrcF7X
         LnSA==
X-Forwarded-Encrypted: i=1; AKwUvBw7dZaMOTZRQaxB6i9HzV/f87Ut3WiZyujLi8/mvXnF8ONXMz4ObnEOrRZN9JceXDVUTlUF5G4=@lists.linux.dev
X-Gm-Message-State: AFq9FYIdLYEN3El5l21HRRuCDwTeeDqcIakpHWO3fQiXi8zdeJ0eRNDA
	TkyLQusKVUqnYVhurZZYeKM8QnXEQ4Za30zqm9YV1bstwBCEespYmHgHfSV4HNj+WrUsuMipJzL
	oP4HPzxA5kcXTR3gvLipIUvh0hS8gDDb31E+C1w/B
X-Gm-Gg: AYBFou0ZHbtl1JjLlYIRIZazA/9uLzZVDmlCjDOKdEe6Le3QpI+Kv9QAGOBZlKtYHZx
	hMO5AHwvx1FA3fWqF5Rwn10SOaqXjB3GcssSZBeVryKd893RenUjyLxQexXDp7pbjKO84DcWh14
	0ya1A4CEPyut2QV0yZDA5nGkRX5y+XAX9X9OMKw/dLgTU7DDBDMgSzAJM82JZkjEeUDyNwjYJPz
	R9cFgHgb9YHKvYj6Kg2oViHRmyMnGzDPaKWnX7G7eKwatjobLgy6xGTiUDNlQ9i1vVzQRfWuDpo
	iFhGvH6k0y5ueZQOvMnomg7Sj62W48QHgbgmGNuz0pEAeyYBkrEDpQ==
X-Received: by 2002:a05:6512:1385:b0:5b8:e262:d32e with SMTP id
 2adb3069b0e04-5bcca7ec141mr318055e87.1.1791371957703; Wed, 07 Oct 2026
 04:19:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261007073537.2454351-1-suzuki.poulose@arm.com> <20261007073537.2454351-9-suzuki.poulose@arm.com>
In-Reply-To: <20261007073537.2454351-9-suzuki.poulose@arm.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 7 Oct 2026 13:18:40 +0200
X-Gm-Features: AclHuK9FLvM3LbOukRQncRzEinU8YnpJHc3NQvReH44DvOmDcByJyESZjTaqDmQ
Message-ID: <CA+EHjTzV29F+MoKAKum1rUS8ZBd2j2w28yQWfHL4ymfJnVzG=A@mail.gmail.com>
Subject: Re: [PATCH v23 08/14] KVM: arm64: Add vcpu load/put call backs for flavors
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

On Wed, 7 Oct 2026 at 09:36, Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
>
> Add VM flavor specific handlers for VCPU load/put, in an effort to make it
> easier to follow the code. pauth traps were removed from VMs running PKVM
> as it is a no-op for them.
>
> Based on a patch by Marc Zyngier
>
> Suggested-by: Marc Zyngier <maz@kernel.org>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Tested-by: Gavin Shan <gshan@redhat.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad
