Received: from mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7DD63E6DCF
	for <kvmarm@lists.linux.dev>; Tue, 25 Aug 2026 08:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787647960; cv=none; b=FssIK1viFdq/RLjWzm/uPVaPTSinpvZhv5JTYnjf+w47RmgE11thHo9SZina/RUSdEwX92YPKpFIOvSnZJCKlZCkSQC3Qq5H267cRj0kebBErZk7h011MQ+st5KXh8eVSwrttfFFwrCXQUVp/hTUNbr6FNFiXg4HzO0ksVm6tpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787647960; c=relaxed/simple;
	bh=MJRz9UsvtPUogXEuUq018MMm0hDrqct732z/+RmQUpg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DJ+ezs0dpZKCaZXta3oqQeCyBitEOg6HqPzdKGgfyIGZRO3iBI9HcZkYWepTsxQPSJ96lNPl5uN0N5gsZt60Qbzkm91jGEY1maADKQMl92VLUqH6N7IGCLd6D3tXE/s75Yh+Durgje4ZIt26KDjIzZ6+nmU1tR6xpVRnoNJxpZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LpQNtkBV; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LpQNtkBV"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=MJRz9UsvtPUogXEuUq018MMm0hDrqct732z/+RmQUpg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787647955; v=1; x=1788252755;
 b=LpQNtkBVZUtYivGnvmk971V/mAA5R0IQPvxY6EcplQXT4q308aQLWkS5IHLaJaxJsFnpx8fd
 DYaQfPCpajI574Z1eMKOrumebQb99UOTpaFO+GKb0Zs4LRLBjwAxRwSlqYSXSH4Jeo4MUAF+nPJ
 2gA+W67+67mGitncQzplwClA=
X-Envelope-To: kvmarm@lists.linux.dev
Received: from mail-lf1-f51.google.com (209.85.167.51)
	by smtp.migadu.com with ESMTPS id 2954b449a1522c4c;
	Tue, 25 Aug 2026 08:52:25 +0000
X-Mizu-Trace-ID: 2954b449a1522c4c
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5b2a73da7e1so775e87.0
        for <kvmarm@lists.linux.dev>; Tue, 25 Aug 2026 01:52:25 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RplcABZrdkVJrxVOBxtF162lgiUcwR3dtfRiqHhac0jt00UDBzYPXGDc9CAX4uPRA/B/b7MgpU=@lists.linux.dev
X-Gm-Message-State: AFuF++k+jdEoV30X/sW4xJACpZK5wxn/qWXrRYpWHycP7ItyfHb0QWQA
	0gHLLOgl1CvhIN/LcTOy/oQYWtL8rLvPKrdiMD8i/AcjSXHLUO/YOzURRuo2nxxNcXQVgchaBlX
	8pCVlQYlX2Ek3WyYnQ8eshhvpe5BHDW7pDTZbKBrW
X-Received: by 2002:a05:6512:10ce:b0:5b2:a5e9:3aba with SMTP id
 2adb3069b0e04-5b49de6a580mr52428e87.6.1787647944151; Tue, 25 Aug 2026
 01:52:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260731143541.956291-1-vdonnefort@google.com>
 <20260731143541.956291-7-vdonnefort@google.com> <yq5afr02wstl.fsf@kernel.org> <ao1OAx_zLwpaw_5Y@google.com>
In-Reply-To: <ao1OAx_zLwpaw_5Y@google.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 25 Aug 2026 09:51:00 +0100
X-Gmail-Original-Message-ID: <CA+EHjTwX+yNayXYD_22vKazzT-yv-9D8Tt_qH0hgPn0-M3kiWA@mail.gmail.com>
X-Gm-Features: AcwNN1U9f1FmJy0X5evuVUC4pyUr9OdSe9hRSm1gkswTc6pqY7URUvwVVrwZ7JA
Message-ID: <CA+EHjTwX+yNayXYD_22vKazzT-yv-9D8Tt_qH0hgPn0-M3kiWA@mail.gmail.com>
Subject: Re: [PATCH v4 06/17] KVM: arm64: Add pkvm_hyp_req infrastructure
To: Vincent Donnefort <vdonnefort@google.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, maz@kernel.org, oupton@kernel.org, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, qperret@google.com
Content-Type: text/plain; charset="UTF-8"

Hi Anseesh,

On Tue, 25 Aug 2026 at 09:10, Vincent Donnefort <vdonnefort@google.com> wrote:
...
> > The SRO model covers more details than the pkvm_hyp_req infrastructure.
> > Should we look at making the two more similar?

Thanks for the pointer.

Where I'd expect CCA and pKVM to converge is how confidential
computing platforms are abstracted to the rest of the kernel, and that
already happens: arm-cca-guest and pkvm-guest sit side by side. The
host to hypervisor path seems like a different question to me.

Cheers,
/fuad


> >
> > -aneesh
>
> Hum, this is really just a few lines of code. Also, pKVM doesn't need a stable
> ABI with the kernel. Implementing a portion of a spec here sounds way too
> complicated for that simple usage IMO. I struggle to see in what way this would
> make pKVM better.
>
> --
> Vincent
