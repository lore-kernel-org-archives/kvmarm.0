Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E74F46AA7F
	for <kvmarm@lists.linux.dev>; Fri,  2 Oct 2026 09:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790933069; cv=pass; b=t2eL7rtWfniR/IlXTn3UYoUU8PICiwZhNKCgIgVf87nwyD3mwC+XxKGXciw9yU2PvyOjsRJdCMQwPsv1LlSAfMzjNPWkFqfMK5EVU4FRu/jnpXJybe1D7B0q+ODYmw8U4GhyrrVG4VUPuXFsDb9Ul2emqv29UfVV9xNeB8XesvU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790933069; c=relaxed/simple;
	bh=7PmFoTV1MhIrlyB9q/nIr5bTRr/fQsMqTgmO60KsB8I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lzmqGDH2fBOfZWnrmNlyT0h7f0Kd92e1NG4aIxTHOY1vbRpjTcdqqFRGj0clM1a8gD3Sk2/qE/N1/k1KtDy5QiTF4LU1JM9mEV7/U2YHBMpGXvZ2FB9zBbjGO70eSxyiuY1uZ93XNeZkpddeviGLOaqK0Bappt69i+aWSwWOdoM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=K0Ws9AGU; arc=pass smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="K0Ws9AGU"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5ba4065fa07so6422e87.0
        for <kvmarm@lists.linux.dev>; Fri, 02 Oct 2026 02:24:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790933066; cv=none;
        d=google.com; s=arc-20260327;
        b=f3w/msQHoyGHrilNqoH8EYfSLa3FxpTbXE380pHJ32aZYc7FObBxCDuothqJnz6sKR
         9tmjPmqUfFgpytO6l3epTU2lFVScvCXaQnzT5x/Rknhes5wtjd4xkxQoKeY1afdUbcPe
         hCdbODAzzR0BZQekKFX2YglST9DSbrvvDUzybElhVASMn9QO7YvS84+sUQks5eV0LLgk
         xSFbzCqU52LRNCI9LBHftnXIw5LBY55pOLniQ8eGcMxr9EqtuhKQRwlNvbUUXqGEmg2k
         434vVEmGQ9aZiGgRwLoGLn3WqdJGlQD23qsMUTOW1K6pshsEA0gjNMrBFKDQemXCAvDT
         SBEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=7PmFoTV1MhIrlyB9q/nIr5bTRr/fQsMqTgmO60KsB8I=;
        fh=lyzWskankqZgmxg3//PhWayYFrtbEYdqEhfEXWskz/c=;
        b=I37jrQMURmJhRSYT6y9QpObZfNJC+ESZ1jo22A07XmARBFz8oXiCz0U1qc11y+ExdM
         5LsbWqzlGuVTMI8TuyZkHkz5BCMnPOUdMwka+fiHQR9WMcwRTQhMsKJtzWQl7Mz4lQTC
         GagrXF4id3YhvCnULixDPq4HGqfv7VGvocPQo8/qomI5HaUOd+W8ZifwpQgyNoVDHvsg
         eJV9H9NGUpeIoeff3Lsl9Dlja7WD5qkpxAd/SkQOZ4wBH1Vt16OKPIozcA3WDGeJoXCi
         aQOWFZPcuz4YQHaxb3YlxTLGbzwmOfzW76WZRxnRyZAQV6+aI6Ad0c38N34MQTXCpP/2
         qoVg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790933066; x=1791537866; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7PmFoTV1MhIrlyB9q/nIr5bTRr/fQsMqTgmO60KsB8I=;
        b=K0Ws9AGULov6hiGdbrgtjnFOpj9fPErA9RjjKYMx7rq0vK2diRIxClAuQOvlyuDnw0
         EMEZpBQ16U3K+1Oaka9B2VAwLV+AME1NX1CCbbrfbTmmEl6m/iZQeisvqwLg9hDkF8da
         6nYzNicNgoluZwc9BeN/mVnv2DCaIpMmRl55Xht9fGQ5bH1C6ct1aIXcnN0VVUFzfkTa
         PXqgTmlkI/kmLmzOzvv0D5sUOfpBxgIbpjqTzmlMfUc7RyZhtUYuTnDeSAlvlwPms54m
         yYuJXxtm91tuLjBKoXMzsrJtWKdfidwgTLc8KrZvMm0l9qFHFOYLYQ+arNgbsbfuYP2A
         pc0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790933066; x=1791537866;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=7PmFoTV1MhIrlyB9q/nIr5bTRr/fQsMqTgmO60KsB8I=;
        b=lNypob7Gz9aGgy2HNlQACNvtx6GtUV6xG5nqutSX7J1gb5P8yrhxMwZUqOnRXhDscm
         QYE5D0AATvUK7e66LH3Aw1flboiPwpWfhEEjaXFzLeusXtwCSNhU4U4uUzBB8KRCrEo5
         pr1TZim94dt/fmB6gflRdp9+gHq9npWkcWKfrD9yA4rNsSiPWTXzPtBbn4hzLMwLrIES
         q7jsNFFaEg2K32xTK2LYcPaijipAYWQm+PKarjqTJApTWCq8mZ1x2Rctu5UBJ6WN/VQc
         wbTgZNoh4M70u0MnLa5mkVCWKbh87rjKyclipcLymDKR4YXu1ePNgYx1nLr/ubXdn1Ip
         TFIQ==
X-Forwarded-Encrypted: i=1; AKwUvBxFN0arY52lkFCpvFLtrlhGbVTW2ZoofCsdkn0S0Z9sl81jfGDQBoIrncPFtfGA1k89cCCdgYs=@lists.linux.dev
X-Gm-Message-State: AFq9FYItJP05uhw61iJ+zjiPvhYi6Oj3LUZ0FQq82jf5qt0Ba5t1LyOI
	AdYG79J662oenClqpCFgr+jBqYq/kVDZloDVxJfPqFSJNTXy20R2MheHXAfTFDcV1OBJBY/J7c0
	wYiSqjLzNN+0dLJwm44za9jOSyQ/y6D4m2fq3ZteJ
X-Gm-Gg: AYBFou2AKGm1XNhi7Y7iF5BW++lZqBE0uf43pKBSzwXkAKX0ZJaarqj0++TsEeK3klY
	OwC0vitxp4DJXIrtn+eoq5vudG8zl5k5TD06CTJyK1G6StsijgwCwkkmgkObJbiw0Kp15YbDFnx
	nmqaaboDIJKSQjvJpTWpvVBJbPonFLZkw8LnMNzO0UMFBaQZNXWVGE7sq3NYzxz83/9H2lOC6MS
	M8DnPQTeOcAC3Ux1v4xyOhsNMRtR6ceDOq4LSJ8ajdvnOAyHGfkJZuTsHmYpCB3OKRBiRCUlNJ2
	/jLalDc/7dvcTmhyJVmMAeuUU4cQsGYdg6mQ/b78ui7kyhJed4ChEHS+o9F0JwUCWn6iLV5eICA
	MyLirn7sGtYZjUA==
X-Received: by 2002:a05:6512:b8e:b0:5bb:ff6f:b4bd with SMTP id
 2adb3069b0e04-5bbff6fb595mr82503e87.14.1790933065552; Fri, 02 Oct 2026
 02:24:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261001210703.1597150-1-suzuki.poulose@arm.com> <20261001210703.1597150-14-suzuki.poulose@arm.com>
In-Reply-To: <20261001210703.1597150-14-suzuki.poulose@arm.com>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 2 Oct 2026 10:23:49 +0100
X-Gm-Features: AclHuK_iAoRmEqRhd3Pqw1bLNIyTQ_Nu4t-bE7ReQMk3jjFJ4DGtZ7fagNuCSDg
Message-ID: <CA+EHjTzz+nmaMDQBXt2e4RU8YcsJOJkVevygJHsq_jbon8PsXg@mail.gmail.com>
Subject: Re: [PATCH v21 13/23] KVM: arm64: Mandate VGIC v3 for pKVM VMs and Realms
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

On Thu, 1 Oct 2026 at 22:08, Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
>
> pKVM does not trust the host. Realm VMs follow a similar trust model, with
> the Realm Management Monitor owning the protected state instead of the host.
> Add a helper to identify VMs that run under a host-distrusting hypervisor.
>
> Use this for blocking ioremap of vgic-v2 into stage2 and prevent creation of
> VGIC other than v3.
>
> Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
> Tested-by: Gavin Shan <gshan@redhat.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad
