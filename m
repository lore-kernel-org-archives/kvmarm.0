Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EB622361DF
	for <kvmarm@lists.linux.dev>; Tue, 14 Jan 2025 13:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736860351; cv=none; b=hybJJZo8NldeHsb56lCIn+fDyg5hjMr+SkFP2ifv4nhal+PvlknYemGEY7FQMLd9WMBqYLw42rziWRic+2NpXFVNaFWcp+yJ6tAZxAHU9LBSb3mPO7XiQ2DvyeBG8cX3lMwY2FzFbu5TZWPVNh17w61OkEuRhtrFA8/b4T83FSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736860351; c=relaxed/simple;
	bh=ufDVwiL/ZNTLSOeaMx+Nt0V5tN0uYwmhgzmZApb6ymU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AA55nDV5asKH/+l5RO5l49xI9JFn7C9AXqg5NfQfMVLQKKQd+uX+jc0BpdtgFK98FUQlMMdB+cTSQIEHae+RA6bXlCa6az5bA10vvbyzw/ZXdroBQrGpz+EBuAoHqVYM8KGozAt0wUaa/QynY1kXXqn51iUmnL26fkicUh4TlVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hfqxjtmH; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hfqxjtmH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736860348;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RWr4LjVLl7XxCHlww7vF1nDasmLkMTAzRIZDCzcHGvE=;
	b=hfqxjtmHzbGl2bjz1tijgx2Xgl2xX0OyxPN0+8ZlZLs+cIGioFvJqx0/gJzVYlmM2Upq84
	jKm9fjn03/oYkvLIEYxYUQpFjEQtMISic9XY05T0LZvQntrGJFJV9VFrOL5+PjQ3FW03Ay
	AR9y4AnBwlewKOQlac/RUd1bhVQwhL4=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-111-gb4uzBs7PD6_1sytLQMXoQ-1; Tue, 14 Jan 2025 08:12:27 -0500
X-MC-Unique: gb4uzBs7PD6_1sytLQMXoQ-1
X-Mimecast-MFC-AGG-ID: gb4uzBs7PD6_1sytLQMXoQ
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-467b19b5641so103382611cf.3
        for <kvmarm@lists.linux.dev>; Tue, 14 Jan 2025 05:12:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736860347; x=1737465147;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RWr4LjVLl7XxCHlww7vF1nDasmLkMTAzRIZDCzcHGvE=;
        b=aV1QAlve5OC1lXknUyFbmQlz3QIxbQeZBNwi6mYO8fSg9GPu0YHS0jFCuksWxkmiy5
         Yz7rdmALLwa8Vqe4cPzqEWYI3shp5RZar/alcM5hynoHrBp5GBWEbU5ystrNKG6AlNP9
         vS+PLJoPIRV59c/qqHFxz2xfuJ4AwzE/1UOsdqZ+gBey6JSDdXaoQj92KT/3gz3PsYeL
         aY5ErdbUelPqcoZy4x65HgwnECi4ZCj3C7tpO93RWAAI1r3b3D0swdKTv7+DhrlCHjtH
         OGYae/5FC+PlmXJoPvKl8+dChDoaOczO/MQ0ftbzji0YqYTFRyRlEF8xz05uTbq6NVzK
         RXeA==
X-Gm-Message-State: AOJu0YykHTq6hNQYd9dOhqKVQRli9Lrt90B4wAzb3+qMiQXf9FHsucT7
	VnarjQap+AeMwL/65oULSyT6BdKzLXN6asMJihpGLKOkmFZCeSWGdgJlh1/MURzQRltgOgcM/MW
	zeV8opqa5bB9j48jOLxV0k20V1aHWZnambwqSkShdBu0X8uEUBBnGmw==
X-Gm-Gg: ASbGncsHt1MLg/MxjJAkfhLyiHJ3FpiFNKrgjGz+k4wiT81jMG5MhOIdFKlzHWNAJo8
	v/FsVSsWMhvC6bLBNXCCNGiGw59OwldW9tqF2YrAhgKubMR9TCPBc4nVmqjmlTjoqKq4h+o3xQO
	8bCNiqqpVfKYw8jJdXhIrOJULZQ6VHdFBCO2at3O9qH1tl8Ezo5iuRAAOkCMP9cShbNjgie7o2e
	LBZMBoGVKOygLiBTgV0szFywbRrK5pX+smbUc05YYYRHQkNoeerOfl4WNRnU0axlxvMNOxipF4d
	AoNXdgU5fGUfK8/vkb6iWs8=
X-Received: by 2002:a05:622a:15c8:b0:467:67db:ef72 with SMTP id d75a77b69052e-46c71028f78mr431226671cf.27.1736860346996;
        Tue, 14 Jan 2025 05:12:26 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHYTexeBR+Gkp5GlViA0tDCn+p6fh/jWMN/XEbbC5wdItpsz+fvQ7pn46wjd/urtfOvlcEkVQ==
X-Received: by 2002:a05:622a:15c8:b0:467:67db:ef72 with SMTP id d75a77b69052e-46c71028f78mr431225871cf.27.1736860346380;
        Tue, 14 Jan 2025 05:12:26 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-46c8732f9bbsm53050701cf.28.2025.01.14.05.12.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jan 2025 05:12:25 -0800 (PST)
Message-ID: <152d262e-641d-4bb1-9656-a13e049d62c4@redhat.com>
Date: Tue, 14 Jan 2025 14:12:21 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: arm64: nv: Set ISTATUS for emulated timers, If timer
 expired
To: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Marc Zyngier <maz@kernel.org>
Cc: kvmarm <kvmarm@lists.linux.dev>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, oliver.upton@linux.dev,
 christoffer.dall@arm.com, suzuki.poulose@arm.com, will@kernel.org,
 catalin.marinas@arm.com, coltonlewis@google.com, joey.gouly@arm.com,
 yuzenghui@huawei.com, darren@os.amperecomputing.com,
 vishnu@os.amperecomputing.com
References: <20241209053201.339939-1-gankulkarni@os.amperecomputing.com>
 <867c89tc4q.wl-maz@kernel.org>
 <c5b1c3d7-56ca-4afc-a831-045dba4beffa@os.amperecomputing.com>
 <865xntt2kv.wl-maz@kernel.org>
 <8be59ff3-6a68-48e1-8181-0ce4b2e7180f@os.amperecomputing.com>
 <bcb4289b-507c-4ea1-afc7-6febd34d88db@redhat.com>
 <86y10osr19.wl-maz@kernel.org>
 <4d443db1-85b1-4071-acd5-3187deb9cb17@redhat.com>
 <2f6b2cb1-3d32-480a-9801-9b993ae74e2d@os.amperecomputing.com>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <2f6b2cb1-3d32-480a-9801-9b993ae74e2d@os.amperecomputing.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 3OUZEmShUGenS1cd4J207vKl6YC_u5PL3EH3io7HkIE_1736860347
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Ganapatrao, Marc,

On 12/19/24 10:30 AM, Ganapatrao Kulkarni wrote:
> 
> 
> On 09-12-2024 11:04 pm, Eric Auger wrote:
>> Hi Marc,
>>
>> On 12/9/24 18:30, Marc Zyngier wrote:
>>> On Mon, 09 Dec 2024 16:46:30 +0000,
>>> Eric Auger <eauger@redhat.com> wrote:
>>>>
>>>> Hi,
>>>>
>>>> On 12/9/24 16:39, Ganapatrao Kulkarni wrote:
>>>>>
>>>>>
>>>>> On 09-12-2024 06:50 pm, Marc Zyngier wrote:
>>>>>> On Mon, 09 Dec 2024 12:25:34 +0000,
>>>>>> Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com> wrote:
>>>>>>>>>
>>>>>>>>> During automated testing of Nested Virtualization using
>>>>>>>>> avocado-vt,
>>>>>>>>
>>>>>>>> Which is not merged upstream. So what branch are you using?
>>>>>>>> Based on
>>>>>>>> what kernel version? On what HW? With which virtualisation
>>>>>>>> features?
>>>>>>>>
>>>>>>>
>>>>>>> Testing is done on Ampere's AmpereOne platform using 6.10 based
>>>>>>> kernel
>>>>>>> with NV patches from your repo.
>>>>>>
>>>>>> Grmbl... *Which* patches? At least give me the SHA1 of the branch,
>>>>>> because I have no idea what you are running. And 6.10 is definitely
>>>>>> not something I care about. If you're using the NV patches, the
>>>>>> *minimum* you should run is 6.13-rc1, because that's what the current
>>>>>> code is based on.
>>>>>>
>>>>>
>>>>> I tried 6.13-rc1 based nv-next branch today, which failed to boot
>>>>> UEFI as L1. Yet to debug this.
>>>>
>>>> I confirm am stuck with the same issue with nv-next on AmpereOne.
>>>
>>> All I can say is that it Works For Me (TM) on M2 and Snapdragon, using
>>> kvmtool, a fresh EDK2 built by Ard, and with the guest running purely
>>> VHE (FEAT_E2H0 not implemented).
>>>
>>> I haven't tried QEMU, I don't have an AmpereOne. I have also spent way
>>> too much time on this recently. So I'm afraid people interested in
>>> making this particular combination work will have to debug it.
>>
>> yes I do agree. I am currently setting up kvmtool to double check and I
>> will debug the qemu issue.
> 
> I could boot Guest-hypervisor using QEMU with -bios and nv-next as L0
> with edk2 (QEMU_EFI.fd) built from upstream tree and fedora-41 as Guest-
> Hypervisor.
> 
> The issue was disappeared when upgraded from fc39 to fc41. Same was
> experienced with the kvmtool boot as well(KVMTOOL_EFI.fd).
I also confirm that using a mailine edk2 fixed the issues I faced
previously (fed/rhel L1 guest not booting).

I used Marc's nv-next branch and qemu rebase.

With a rhel L1 guest I can now boot buildroot, debian and rhel guest as
L2 (feat mainline edk2). For rhel, I tested different kinds of page size
combinations for L1/L2 (4k and 64kB) and it worked.

I tested on AmpereOne and Grace-Hopper systems

Eric
> 

