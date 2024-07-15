Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EE49187345
	for <kvmarm@lists.linux.dev>; Mon, 15 Jul 2024 10:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721040249; cv=none; b=m2YmdIbtzc849kAaPBf+M3R8fz1b80XdId5608QyvmFvU0iXgSI0O9NKnUrrW7aYw4DSaF6wU+B89TJ8DWa4DlKCJNL6KbpX0gRMK5tMeTIQ4t4bSsbfgAhSYy/INV4cAxbGK6ocujWmGxYf+GjeRBQ72EYEAVm+LBxW4/WuMVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721040249; c=relaxed/simple;
	bh=XMXUsVqA3WkYY2uXqSIqKh4XNGjjobx5UJJk1PrkZ+8=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=FR/y8JDaDaWo+/TMvBtEVWONe4FcurXVc0l7qDoh122Zpiwu6zXlT6dWRv7sMpwaOmcBgOLGAsstr74mfH7aL0IN9+oqSO4jV16u9JaPFku7bOumCw/qdhfHz1hnfEOGBINdvBSdvJtMMEV02Bf1YmTwgPGBRKtUh3sHuQvWerM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DF40PlWs; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DF40PlWs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721040246;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1VDMt6BhM03zaBmAW1YFT8GRu72U5uXIitRTt4yVWtY=;
	b=DF40PlWs8AsWIPax1j18E88dfVSznU4JF7CnzL1qybzYPpVa5LhSMRx1stxf5NDGGU30UK
	JkSoP7E1oomNVasi105f8gE0Lq01p+EO+7duEt5uPqEuWNn/sEi8L1GTVfDwcODtheXrrr
	/IdqnVjYO8sqdh37OrTOU9+4HYlT2f4=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-606-iU97i0N6PpatHUGGUosDwA-1; Mon, 15 Jul 2024 06:44:03 -0400
X-MC-Unique: iU97i0N6PpatHUGGUosDwA-1
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-44b181a4edaso91167461cf.1
        for <kvmarm@lists.linux.dev>; Mon, 15 Jul 2024 03:44:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721040242; x=1721645042;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1VDMt6BhM03zaBmAW1YFT8GRu72U5uXIitRTt4yVWtY=;
        b=dYkYbUQGpTTj295OamSZZXg1rPOPUDDiJ0897UJh+u/wjiJ9/1B+a8of4toRRqgFIP
         SI/HoxB80jDL64ybU5LLwLDbdupFp4zyJqGrqe5ntiI5X1QRi0yZiKW7TZYlPSmNstpR
         T+3UrfYX8ycNi/MC42V4qSQ132oenhf8skKP76qrGMLTLvCExXQ7H59+OiJaTVDfxZtr
         HX4ghw53Pqz+yJn1CNhC5MeDm7P6XQ+urE+HIP78nadYF2cXnV/kh0aYGZ9jsZXx49a8
         g6ofI8k2Nc8WHxcMkx4rk/c+4RfqAcZdG/FBfJEbb3ZiAq/Wy+zx0SluA08ov4IZ+YvN
         fZgg==
X-Forwarded-Encrypted: i=1; AJvYcCVkjpqn9yMXM9rJfQAfD2vn8GvatKpfYu61VOVSJi2fzNoRqbFA9A+8vScWJQgKNK7K/DqXKPhBrVcUp1RIXs1i3P/VMaBN
X-Gm-Message-State: AOJu0YzPrK0SNsFi2Fxq3bVBxxHLv0nY2dCSDJQL7R01AebvvUhbPdpL
	8BsZAsVHQQGmL1zRAyYYds1Oy7G0cE/9LYMoku6NtxUESNbjZmMQqPhDVd59mvyxRNS91uMrAY6
	BQ8BkBPLsm20yxgbvyXhJlos4+MDfytOXAyEmKt7Gomwugm8eMF9BNA==
X-Received: by 2002:ad4:596d:0:b0:6b5:2be1:cd6e with SMTP id 6a1803df08f44-6b754b6be33mr172946316d6.4.1721040242560;
        Mon, 15 Jul 2024 03:44:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGrz3doHdIu7jIfoH+wiwb6f5b4GbXN3svlFADmcupRvZiDKcsGzoKyXQkY2C/ZlEeQe0uF7Q==
X-Received: by 2002:ad4:596d:0:b0:6b5:2be1:cd6e with SMTP id 6a1803df08f44-6b754b6be33mr172946076d6.4.1721040242215;
        Mon, 15 Jul 2024 03:44:02 -0700 (PDT)
Received: from rh (p200300c93f45e50062e5f8c654844c9a.dip0.t-ipconnect.de. [2003:c9:3f45:e500:62e5:f8c6:5484:4c9a])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6b761957786sm20124196d6.14.2024.07.15.03.44.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jul 2024 03:44:01 -0700 (PDT)
Date: Mon, 15 Jul 2024 12:43:58 +0200 (CEST)
From: Sebastian Ott <sebott@redhat.com>
To: Mark Rutland <mark.rutland@arm.com>
cc: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org, 
    kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
    Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
    Suzuki K Poulose <suzuki.poulose@arm.com>, 
    Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
    Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 1/3] KVM: arm64: fix override-init warnings in W=1
 builds
In-Reply-To: <ZpTtTQ-ysRGw2tZG@J2N7QTR9R3>
Message-ID: <d3bd266c-922f-d1b6-5b14-edd892ad7fd1@redhat.com>
References: <20240712110332.10970-1-sebott@redhat.com> <20240712110332.10970-2-sebott@redhat.com> <8734oep96j.wl-maz@kernel.org> <ZpTtTQ-ysRGw2tZG@J2N7QTR9R3>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Mon, 15 Jul 2024, Mark Rutland wrote:
> On Fri, Jul 12, 2024 at 10:55:16PM +0100, Marc Zyngier wrote:
>> On Fri, 12 Jul 2024 12:03:30 +0100,
>> Sebastian Ott <sebott@redhat.com> wrote:
>>>
>>> Remove double initializations in cases where that's easily possible
>>> - like extra NULL initialization in static global structures. In the
>>> other cases just silence -Woverride-init.
>>>
>>> To fix warnings like the following:
>>> arch/arm64/kvm/hyp/vhe/switch.c:271:43: warning: initialized field overwritten [-Woverride-init]
>>>   271 |         [ESR_ELx_EC_CP15_32]            = kvm_hyp_handle_cp15_32,
>>>       |                                           ^~~~~~~~~~~~~~~~~~~~~~
>>>
>>> Signed-off-by: Sebastian Ott <sebott@redhat.com>
>>> ---
>>>  arch/arm64/kvm/handle_exit.c     | 5 +++++
>>>  arch/arm64/kvm/hyp/nvhe/switch.c | 6 ++----
>>>  arch/arm64/kvm/hyp/vhe/switch.c  | 3 +--
>>>  arch/arm64/kvm/sys_regs.c        | 5 +++++
>>>  4 files changed, 13 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
>>> index d7c2990e7c9e..2c049746657c 100644
>>> --- a/arch/arm64/kvm/handle_exit.c
>>> +++ b/arch/arm64/kvm/handle_exit.c
>>> @@ -291,6 +291,9 @@ static int handle_svc(struct kvm_vcpu *vcpu)
>>>  	return 1;
>>>  }
>>>
>>> +__diag_push();
>>> +__diag_ignore_all("-Woverride-init", "Allow field overrides in exit_handlers");
>>
>> The wording you are looking for is "Silence stupid warning". I really
>> mean it. There is really nothing wrong with this code, and if the
>> compiler doesn't understand the purpose of a default initialiser, then
>> *maybe* it should be fixed rather than polluting the kernel with this
>> stuff.
>
> IMO this would be a lot more palatable if this were an attribute on the
> struct or assignment, like we asked for in the past:
>
>  https://lore.kernel.org/lkml/20190809083251.GA48423@lakrids.cambridge.arm.com/
>
> Having something that we could put specifically on the default assignment would
> make this a lot more legible and better capture the intent.

Yea, I double checked in the gcc doc - there seems to be no other means to
silence this per var or assignment. We can disable that in the makefile
for the whole file or dir or we keep it as it is.

Thanks,
Sebastian

