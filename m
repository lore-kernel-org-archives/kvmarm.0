Received: from mail-io1-f73.google.com (mail-io1-f73.google.com [209.85.166.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD50752F97
	for <kvmarm@lists.linux.dev>; Mon, 25 Mar 2024 20:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711397528; cv=none; b=epLzIoQyeaz7IfA/UqSxE1JEeEdepLLH6E1cJse3mISMNzraFjgEpw7NzKbW3a8j58X8Ct9Nnqb19THZvuueV9NdMOa8Rvn5R0kNt0mgBIVsEdj6CZmdHuy1Qo19wpJllBAPdn6KzpHdSKx+V7gU/I3idLk7EV5dDNjuXwu/K60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711397528; c=relaxed/simple;
	bh=TS58LtBep+V3y21GNNI5AUCkkhJt90huKHWlMzlnjIk=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=ffbZAq5suExqzMt5MHfftyktiFAJkXMobKTyFxcCXowFeZsFNnnzwoZerpt0hV2XIZcNgiu7kXkFzBZTf8StNhfqLph2z5Z0MvtciX1Sz0zmXhkojipXQMUIzAWjSzF9VFceNJsLKjJviFxSjyXftpLuL/AtiXJC2y21C2GJgF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PYua8RSR; arc=none smtp.client-ip=209.85.166.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PYua8RSR"
Received: by mail-io1-f73.google.com with SMTP id ca18e2360f4ac-7c8742bedd4so359501139f.1
        for <kvmarm@lists.linux.dev>; Mon, 25 Mar 2024 13:12:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711397526; x=1712002326; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=T2hv5W0oxITVtYMp7qscmbVqdlTYLfE2MA0LIJYCuQE=;
        b=PYua8RSRw8cQgdyNKBlrCsdxG9QrqVSICv26vd3XUxTQltPtGg3rGXzDYaMPCwI+97
         7jX31fNWFN7leGTeoPLvADHV8TVAfYp0zsKnpcFQevuX3jWvYPo8D1H06q5PEvMqjIwI
         mobFvedhMYXgDuWepLsTjwaeAjtcAd1b4gUY8z4gQlU5IC+gukNgbLHdwAs3QnYBzVv9
         LDYwG29/fqOmHb4iWLbkpw5oKepK2yjvaCh1KORNJogwvJVtrUAQhwTEXczFepyUmMsJ
         +fOOth7lCfSvJipETQeVMyDnZYoBEWAkajgObQ5aXzCx8fB4pBeucPlp4ohwTytYcemR
         aWgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711397526; x=1712002326;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T2hv5W0oxITVtYMp7qscmbVqdlTYLfE2MA0LIJYCuQE=;
        b=wYnzpfQkh/C3CIJuB31zsBj646mtE+GdFHuYGAGvmfNA3gDC148MkMRXgFOf5aUxzi
         qkb4Nk4F4fE68uahjTh+V6c/V5AD4r3BhjFVPuRyhRchuepNrvgVMQ2yk6u6zP1NjlPG
         XoylIizPCE/GM/06meaV8xgRCQfwtZ4SIGBWvUUuxegl19oe66KCI4wC3M8kIpDxetya
         J69sCan8QgR3DLVAzKmcV64mtrol3TN0oBkWjxL3m7T+9m9cyC6I3shbsyki4ymGIRor
         o9fKaCW7kXl1wqTB2tdC0gbx079WPxYzfSPBs2JZN58VC3i+i2datsxmsCV6BJ8ELq2m
         Ythg==
X-Forwarded-Encrypted: i=1; AJvYcCU2PQQ8rMKYUxGBfA0DHjpZDP1i1+I1BR2Y5n9bsK78ZaQGEhALbr6mM77myMJVbPppRtKZ6xBp7Q+1nTKC74U4Gy2O9YZj
X-Gm-Message-State: AOJu0Yw2LqtgXiCWkXmAHLtaT488ywuTvYHHhCHGJYVdH0AUHjy0Nl0D
	VAHE+Vy21cn/eBugUvYcZweSg1Uq/ZHF8JagqRGrELj1+XeeW+GsIfAZjIB61+fcn322Orv0LhY
	cMEtZ8lVPanDgrbEkIwWl6Q==
X-Google-Smtp-Source: AGHT+IFCjgD983eCqYT6Ydi/m/c3Lfnobnc1zjBwoflNgQEaRbyw02u5gMlW85KgYgJ6uWEVFXJUhDbaLvXhfNn8rQ==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6638:3724:b0:47c:125e:7f3e with
 SMTP id k36-20020a056638372400b0047c125e7f3emr304187jav.3.1711397526087; Mon,
 25 Mar 2024 13:12:06 -0700 (PDT)
Date: Mon, 25 Mar 2024 20:12:04 +0000
In-Reply-To: <Zf2W-8duBlCk5LVm@google.com> (message from Quentin Perret on
 Fri, 22 Mar 2024 14:34:35 +0000)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsntjzlqax63.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v2] KVM: arm64: Add KVM_CAP to control WFx trapping
From: Colton Lewis <coltonlewis@google.com>
To: Quentin Perret <qperret@google.com>
Cc: kvm@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, pbonzini@redhat.com, 
	mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com, 
	vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, 
	bsegall@google.com, mgorman@suse.de, bristot@redhat.com, vschneid@redhat.com, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Thanks for the feedback.

Quentin Perret <qperret@google.com> writes:

> On Friday 22 Mar 2024 at 14:24:35 (+0000), Quentin Perret wrote:
>> On Tuesday 19 Mar 2024 at 16:43:41 (+0000), Colton Lewis wrote:
>> > Add a KVM_CAP to control WFx (WFI or WFE) trapping based on scheduler
>> > runqueue depth. This is so they can be passed through if the runqueue
>> > is shallow or the CPU has support for direct interrupt injection. They
>> > may be always trapped by setting this value to 0. Technically this
>> > means traps will be cleared when the runqueue depth is 0, but that
>> > implies nothing is running anyway so there is no reason to care. The
>> > default value is 1 to preserve previous behavior before adding this
>> > option.

>> I recently discovered that this was enabled by default, but it's not
>> obvious to me everyone will want this enabled, so I'm in favour of
>> figuring out a way to turn it off (in fact we might want to make this
>> feature opt in as the status quo used to be to always trap).

Setting the introduced threshold to zero will cause it to trap whenever
something is running. Is there a problem with doing it that way?

I'd also be interested to get more input before changing the current
default behavior.


>> There are a few potential issues I see with having this enabled:

>>   - a lone vcpu thread on a CPU will completely screw up the host
>>     scheduler's load tracking metrics if the vCPU actually spends a
>>     significant amount of time in WFI (the PELT signal will no longer
>>     be a good proxy for "how much CPU time does this task need");

>>   - the scheduler's decision will impact massively the behaviour of the
>>     vcpu task itself. Co-scheduling a task with a vcpu task (or not) will
>>     impact massively the perceived behaviour of the vcpu task in a way
>>     that is entirely unpredictable to the scheduler;

>>   - while the above problems might be OK for some users, I don't think
>>     this will always be true, e.g. when running on big.LITTLE systems the
>>     above sounds nightmare-ish;

>>   - the guest spending long periods of time in WFI prevents the host from
>>     being able to enter deeper idle states, which will impact power very
>>     negatively;

>> And probably a whole bunch of other things.

>> > Think about his option as a threshold. The instruction will be trapped
>> > if the runqueue depth is higher than the threshold.

>> So talking about the exact interface, I'm not sure exposing this to
>> userspace is really appropriate. The current rq depth is next to
>> impossible for userspace to control well.

Using runqueue depth is going off of a suggestion from Oliver [1], who I've
also talked to internally at Google a few times about this.

But hearing your comment makes me lean more towards having some
enumeration of behaviors like TRAP_ALWAYS, TRAP_NEVER,
TRAP_IF_MULTIPLE_TASKS.

>> My gut feeling tells me we might want to gate all of this on
>> PREEMPT_FULL instead, since PREEMPT_FULL is pretty much a way to say
>> "I'm willing to give up scheduler tracking accuracy to gain throughput
>> when I've got a task running alone on a CPU". Thoughts?

> And obviously I meant s/PREEMPT_FULL/NOHZ_FULL, but hopefully that was
> clear :-)

Sounds good to me but I've not touched anything scheduling related before.

[1] https://lore.kernel.org/kvmarm/Zbgx8hZgWCmtzMjH@linux.dev/
