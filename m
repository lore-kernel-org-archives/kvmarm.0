Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1170F36657F
	for <kvmarm@lists.linux.dev>; Wed, 21 Jan 2026 18:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019279; cv=pass; b=Jyn4RxqDr9V76o/0AU7obtwr6ybjQ9esdUuDCGt+OzPGj5SOT1dsjeAosXG3V8hEYVsZYsUiRQSRGyrS+YJIPXTUAuPpZ2ANB5X8AaCqPh6dAiokffJ8t9SRp9vMQVn4OaEJGfroQbXcawfP7uLyq8OszuzLJvXU0cXo9N0c0EY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019279; c=relaxed/simple;
	bh=jZTDYWMIg5iiS9eFNt7zYyloZsIcfB10ut4qe4HKgQg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FbBXG9ns9ddTbcSs+Y2NFzO8kqa7H+ikgQLoZFmv7bQuAJ4g7XfBSl9xykIAGjcCKyTTj1NWP3MBA65Zq2GcNboGVajDPxNhjAQTF1fhbAeYranczwi9rjnL7stXiOxcHXrNLrc8lcbHAcLBX4m7mRwbH2LvYgRTaoZoE7oWI0o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EwY3hG9E; arc=pass smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EwY3hG9E"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-47ee730612dso3945e9.0
        for <kvmarm@lists.linux.dev>; Wed, 21 Jan 2026 10:14:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769019276; cv=none;
        d=google.com; s=arc-20240605;
        b=FalCftJ+Iv6JWvziTHuiUpvsDtZABkaTlqkOTa7sec09GAX9SlYAijiy3XvgcRkgf0
         WgvyCYzKM34deRyxGfDxUmQnjhyuvlEZ8BZ7U//F7xc05r0j+2+ma4g33pONqAlwo2Cu
         SUT4XoMgXqSNieu5ShucZ/VhpdDMW6YqC7saqqQmjEUI9UzL/L3KWIOW0Xh/eBtZD+KX
         EY8As+dqAszBC1E+C0s2jKbVJYHcrCCCCQ3OJTBaFjPjdPsjCHIK4L3jRGmHsUn5gocN
         9WVCbIEoEYZHjByQ/J99NdLZxOZUufV8COx0ZrlLeA/JOMwjQTyVIoGnPeDz9CjpzxwC
         DFZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=p5XVqIJKmTdNg//3T8VtD062hEHwYD3wbewTGcUQHww=;
        fh=clnHTzAvt4aYOa2Pra7MMfnGJgWCg3sy4xV9cvJ65Tc=;
        b=MG1I6EApN204advvFA9eKBZmD7vvgNzchTeF5AdIEvMa7bRqy/3EXp7nOA7wSPhAAv
         zRP38AKnd5/t6XB/hl9nz0CUO2lXX9D5+B1zU3idY+x8I8I/B5ugqHY8vxIh6iysW17C
         AlK36uv38/QpPLMQHa8/m/NwhtcrVKY0F0/38HR5/+V5SzxmKP5RJG1i3YAWS59/bhiW
         rjtL+Vj5rPCK1gRLEvWU080SyaKjJ5sGMtBB7CZK5fz9o+z8C62KaXiyadk6xMvG9PjK
         nDdkRJriBmks9XOfYBeDy//7staHFFJzSyCaobtEcrkEP53BgAdYFS4glT2wtJIRYR+8
         7xTA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769019276; x=1769624076; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=p5XVqIJKmTdNg//3T8VtD062hEHwYD3wbewTGcUQHww=;
        b=EwY3hG9EYE2GS2tttqLZNxuFZZzAnDLqPVaWk/aMz6cVVVcq72lj8l/uivSe555rD3
         wxJ1RdT2yUgteL/vLbetqVCGhGvd0L8ecNv2JVFghgfFlkuaA77ljVg9huzoW/tbjY0S
         SoChqyTWllFBiZHJdSpbRDJwX4cY1PK2br4OJcbESu+BPelTiQpPcSgI4DNBltVJSy6B
         mF+ilTCQb6b5NtPNAQeLZL2Vn5PfniQ0wvmkVYIvGuQ8dEHRIWDiKlYG9NPYbfczM8iU
         X4RsFdSe2Is+GdB1Hmdumvh71WkqUfOsd3ZXX+gNrtkMAsIKhIKfCn2lBga/Y+W9B8/w
         o4EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769019276; x=1769624076;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p5XVqIJKmTdNg//3T8VtD062hEHwYD3wbewTGcUQHww=;
        b=PKicn8wxsc9Z0uAfnHKatMST4prVXD0CmWlS4SDoifoYkIR+i+Ec2D6PCCSe/ICMqg
         0wZjTUQu1cEQl0GbaCtiV9qdhNZfYm5uD0Td6TYxyyuJennI2uEdULeSwQmyY1qQI8It
         psY0B5bFPU/E6WAKn0zsCxh3UlIhNtmVvdISSb+zRs4rjDfALVHWcNq1R3SNmac41Ivy
         HjocJWIxcCMR8EY7C7wbjpVWeB80sKQh0u8dGVFZXS/JZ9uX5ZKYlm290npKe0Z3OSMC
         2v2lo0tZjJ2VvRSJ5lxBCnovcThHkyhyJ2USkbII45ZrgOwpwyeCvsScFBnepppzq63o
         Hnwg==
X-Gm-Message-State: AOJu0YyjS4Y4BIdIcLwuiL3UR99k1c9k9jVmmrAaBtAUWhXrD2ZAPmTJ
	5yJIrD+zC44v/llMWhPESvheWJ6ZkhUC+VNjH3TyZA9qMbSFkLPW5xpp6BYpA5GwvUdAU+/u6xn
	5HlhJH2Q/dWH/jfjthrZS0haeXLgnrxL3DsRC94a+
X-Gm-Gg: AZuq6aKuVYi5wkx/r2dhzZSTa0TKLzpMJetsRS4k3xrEa+WyyQYXWSKJS2ZNqS99Gqt
	upPNW1+PIbKgJStGggswkaAzG2gIX9fcGlNbsx+aD2ofQN8Nn4rRYlcVkBgPozT2K2jEIFFLcfY
	Vl7t+K2B3ZIc6qhd84Rr/S/ElrGuvpdKzGHL8WX1aVuC+jvPMV2eBivl8lrSGyPm2JUX7c2ZIxs
	/Gh6l+tXWOTmhpqIwvgeUsRz9OmMsNGOSp9U/eH2DMckxW5jZUQcjSnpP0RJe+mns6zBn3t
X-Received: by 2002:a05:600c:6384:b0:477:563a:135c with SMTP id
 5b1f17b1804b1-480477b51a1mr26765e9.0.1769019275979; Wed, 21 Jan 2026 10:14:35
 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260119105651.255693-1-maz@kernel.org>
In-Reply-To: <20260119105651.255693-1-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 21 Jan 2026 18:13:00 +0000
X-Gm-Features: AZwV_Qh_YeP54R4FLco28FynJf9u8bOykNrY9GWkuwWxdnhQ-4o8kYRPJgfG68U
Message-ID: <CA+EHjTzN1hUZCW_muHwapRQopFaju-zRPZygxKoyfYS1XSYNSg@mail.gmail.com>
Subject: Re: [PATCH 0/6] KVM: arm64: ... and FWB for all
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Quentin Perret <qperret@google.com>
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Mon, 19 Jan 2026 at 10:56, Marc Zyngier <maz@kernel.org> wrote:
>
> [Yes, you can tell what I was listening to]
>
> Today, running in protected mode puts the host under it's own S2 with
> FWB=0, even if the rest of the guests are running with FWB=1. The
> rationale for this special-casing of the host is that we want the
> combined attributes to actually reflect the ones exposed by S1.
>
> We therefore use NormalCacheable (which is the weakest memory type) as
> the default attributes at S2 so that S1 can only strengthen the final
> memory type.
>
> But there is no reason why we cannot achieve the same effect with
> FWB. We normally use FWB to enforce cacheable memory from S2,
> irrespective of S1. But it is possible to configure the S2 attributes
> as "pass-through", so that the S1 attributes are always used.
>
> This small series implements that change, adding a flag that actually
> describes what we are trying to do (instead of the NOFWB flag which is
> pretty obscure), and fixes an interesting gotcha with CMOs.
> Interestingly, CMOs never actually worked with NOFWB on an FWB-aware
> platform...
>
> Patches on top of 6.19-rc5.
>
> Marc Zyngier (6):
>   arm64: Add MT_S2{,_FWB}_AS_S1 encodings
>   KVM: arm64: Add KVM_PGTABLE_S2_AS_S1 flag
>   KVM: arm64: Make stage2_pte_cacheable() return false when S2_AS_S1 is
>     set
>   KVM: arm64: Switch pKVM host S2 over to KVM_PGTABLE_S2_AS_S1
>   KVM: arm64: Kill KVM_PGTABLE_S2_NOFWB
>   KVM: arm64: Simplify PAGE_S2_MEMATTR

Glad to see the host is no longer pulling the shortest straw on memory
attributes. ;)

I've applied these patches on top of the pKVM Android branch (with one
small fix to the Android pKVM code), and tested it with qemu on cpu
max (fwb) neoverse-n1 and cortex-a72 (no fwb).

Tested-by: Fuad Tabba <tabba@google.com>

Stay tuned for the reviews...

Cheers,
/fuad






>  arch/arm64/include/asm/kvm_pgtable.h  |  7 +++---
>  arch/arm64/include/asm/memory.h       | 11 ++++++---
>  arch/arm64/include/asm/pgtable-prot.h |  4 ++--
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c |  4 +++-
>  arch/arm64/kvm/hyp/pgtable.c          | 32 +++++++++++++++++++--------
>  5 files changed, 39 insertions(+), 19 deletions(-)
>
> --
> 2.47.3
>
