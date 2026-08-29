Received: from mta1.migadu.com (out-120.mta1.migadu.com [95.215.58.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F1D43C0A09
	for <kvmarm@lists.linux.dev>; Sat, 29 Aug 2026 15:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788018969; cv=none; b=Prek5JfmbVRdePMcmlwQqUMxTv1GtgzOa6zjUClDM9hNWfIR6M6jhgFTyBa03R1y6S3K8woMhQd03KOPshBMlWDdAEVKiWs31S9whEiBp8OqCX2IxePwEt41DIeJ+2w03HwAwWiszSE61vaLhDWXqPujpMBqTPnaV9EoPoAJ6po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788018969; c=relaxed/simple;
	bh=3dTe4I+jOUWdWEDTdrRhpKO6zN5DvkrePHACeVTRXMA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tHjRP8j1nNNAA7PxaaVOYPfdED2fX5mBXdjH5X6WTetp8Yhav8aHOgYEh3+OuRQNTqP73hUxa0Y1LpDFiLJ/8vBPV54BiSKxPT0RQ5Q3KEmGufKMQeglzfX7hHtWa8DZ1G2mVxEdePaKHyFbjiODM4RISQ6v6EvM6JFDAc52Z+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dVvsLidc; arc=none smtp.client-ip=95.215.58.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dVvsLidc"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=3dTe4I+jOUWdWEDTdrRhpKO6zN5DvkrePHACeVTRXMA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788018957; v=1; x=1788623757;
 b=dVvsLidcMR1dWi8BRMWNvY2WiZ7LvSHOqx/DoN+uDn0bNJi5i0K+PMyx9ExsmYnbBquGVCd6
 iLzYQ1ap5VaYAHd6KkxAy4HXom3iQulxuXZTQJrYaIjHaQ08K5tMGqVMRay4znTB8N9Nny+qZD6
 OFfbYsM39yzNm24lwUQQh7o4=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 2f78d3edf92b2df7;
	Sat, 29 Aug 2026 15:55:57 +0000
X-Mizu-Trace-ID: 2f78d3edf92b2df7
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5b2a73da7e1so4302e87.0
        for <kvmarm@lists.linux.dev>; Sat, 29 Aug 2026 08:55:53 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwCjATc0mo/Td5o1+ChhE5ayDa9R06Md7eeyM9XthlNCI8/mzDS1WxwW8G3lD/JcMQCsoxRV+o=@lists.linux.dev
X-Gm-Message-State: AFuF++nug30zMW+yN9294oFDxCJ1kAj+NfJVUvvxR0ZSR29BN9cCI9Qo
	KW/WMlKszzsJx3vMU52PVPdlO/A0Bj9B2PGObBQZ7KK8kQukLV6pPOIEH6IxQbUDvyWnwy3Dg4K
	BGuAM6wwvkWlJNQxcmU4pznaHnIwZW7ks23lBrhy4
X-Received: by 2002:a05:6512:4484:b0:5b1:ca0b:25d2 with SMTP id
 2adb3069b0e04-5b5ef1bf21emr94137e87.4.1788018952785; Sat, 29 Aug 2026
 08:55:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260829054856.70549-1-kmehltretter@gmail.com>
 <20260829054856.70549-2-kmehltretter@gmail.com> <CA+EHjTzQM0bf1x2X-Y+eMmUHSYUmJXpt_jQ4Csu7JpkjtFT72Q@mail.gmail.com>
 <apL9jzg-KM_n3Vv2@gmail.com>
In-Reply-To: <apL9jzg-KM_n3Vv2@gmail.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Sat, 29 Aug 2026 16:55:16 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzP0ijpos=1UOTz36b6_e1Ux90rNPm8HV5AKRhMOd76Zg@mail.gmail.com>
X-Gm-Features: AcwNN1VTjw50xqm9AUGeQ2iOjooRY4VH0Aw3j5JN4xMy5Uv_aVYtiX-pVxGi2Is
Message-ID: <CA+EHjTzP0ijpos=1UOTz36b6_e1Ux90rNPm8HV5AKRhMOd76Zg@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: arm64: Return -EINVAL for an empty SMCCC filter
 range at base 0
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sat, 29 Aug 2026 at 16:53, Karl Mehltretter <kmehltretter@gmail.com> wrote:
>
> On Sat, Aug 29, 2026 at 04:04:01PM +0100, Fuad Tabba wrote:
> > > Fixes: 821d935c87bc ("KVM: arm64: Introduce support for userspace SMCCC filtering")
> > > Assisted-by: LLM
> >
> > nit: this should be `Assisted-by: AGENT_NAME:MODEL_VERSION [TOOL1]
> > [TOOL2]` rather than LLM
> >
>
> When I first saw 'LLM' in a patch I thought so too.
>
> But it is now allowed, see recent discussion and merge:
>
>   https://lore.kernel.org/r/87qzkuahlr.fsf@trenco.lwn.net/

I missed that. Makes sense to be honest. Either way, that was just a nit :)

Thanks!
/fuad

>
>   816d9992d9ed ("coding-assistants: simplify attribution")
>
> > Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
> > Tested-by: Fuad Tabba < fuad.tabba@linux.dev>
>
> Thanks for the review and also testing!
>
> Karl
