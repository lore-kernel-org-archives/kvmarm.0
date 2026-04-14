Received: from mail-oo1-f74.google.com (mail-oo1-f74.google.com [209.85.161.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEC87282F3D
	for <kvmarm@lists.linux.dev>; Tue, 14 Apr 2026 19:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776196532; cv=none; b=STB9NBvd2eD2Hp/aZak62H94hygUSszxbjxiY9OiyMt0rNOefKPlF5bZRjaS7idbS63U2vs7WUdWcDsS5o6MwJ4bFZiGZCF9t5KupXTCI+eQH3CTb8oyIyp7vUynNNqlElIJxrbaDhSjehMOG12MQsDy0tPzdcudtPPJxv4iHrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776196532; c=relaxed/simple;
	bh=sGPFZnIQdpvtj8pWF29yE7FXHvTUdwtT/N494dsATCQ=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=HNNuwXQ70bQ1SByrrpgJITswbW7LRU6pCSAUiEbGgrwSc3fFW+ijVVJQqZrs6N9Kw864pthwuh3GXzkoiW9Z8vuhczXLKWuFjs3jjbR/rMs40apyEzHDnNAT9trbdhcZhQeceZZW+viaOg2MofCqSVL28DLXdk+ykzzXpDGPepo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=R7R2dGAI; arc=none smtp.client-ip=209.85.161.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="R7R2dGAI"
Received: by mail-oo1-f74.google.com with SMTP id 006d021491bc7-68e7e213adfso6617102eaf.0
        for <kvmarm@lists.linux.dev>; Tue, 14 Apr 2026 12:55:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776196530; x=1776801330; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=sGPFZnIQdpvtj8pWF29yE7FXHvTUdwtT/N494dsATCQ=;
        b=R7R2dGAIYIhlPl8TuPYFKuBEyktgKEdZFksI0Bx52igQw+QfGi0Z1saO1hrwPCDIeV
         6brvHiEwj4USTw2Gxd1M8Z13K94op2GebW4NFpS8cKvdnXYPSJetFQTNYuTkYzCLseGU
         OgIaNhWL8NGyNj42ECHDL6w/0wuqhY9+CTolUUvMeW6AG2urJKvJwH0J79W7x09+aZLR
         eBRvukBEanUM47LKkaV72XnrJvcm7NvaJeYrlB1Y9QoLiD9ZWonwCoVVFBcakW2FAbzR
         f6lODIp9GpAzSOFzVWTSfoXDyfd9gMZbiKqTjjZ7N53yIXzJ5jMOpI65S9eYEWKDd9ui
         KghA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776196530; x=1776801330;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sGPFZnIQdpvtj8pWF29yE7FXHvTUdwtT/N494dsATCQ=;
        b=k938L1oY5dSRrSON0AhjNd2J3+pK2Z4uOR8yv7b/KpYWAmSVIERz5j7LRuIMjxsL4R
         kcion803Z55Nk5llekvXMqEplINdoviSV+LU6jaB5VyfGG5+Si0NLf36oWdcl912hrik
         51XepvNqq5SgOvlS5/54i/PNNXpiXecFYv9k5R5Pv+jKd14LXfQDpRqv0IB9DHgbE1/B
         XTF2kgk6x1dMdZv4D6ETabh3NPq0uUoruaFlkC/pz7MM93JUwFdG2hCK5vndYVHWmj7T
         3NR5GV7XQ9fslR44JwR24lKiugdXWSvW+ZiWLoNgPwLz6KRvbQEiujhHuyRgcRbtv/v/
         wrUg==
X-Forwarded-Encrypted: i=1; AFNElJ91r/NW5+K3dt/OtWQw4Tl53RfNOhMzND4mqs5OQRsvyercqlVKwxigf1/7in1Y7Pl8tEJ0U8I=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx1Qk1MBF3m8ICggj9oIL0xJ05tED9u5UAMJ9zqtU5ddeTniwr+
	GTgdjiiG6s3ZQkuB9LGtG+haOrK8ZNThlx2RC+eXSsQctJdysh/9Xc8cyxmxlFTrpKVv2StEoeZ
	LN7hwKsC6tcY/49WHIieqRNz6kQ==
X-Received: from iljv10.prod.google.com ([2002:a05:6e02:13ca:b0:4fa:147e:ab1d])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:812:b0:68d:dfd2:8db8 with SMTP id 006d021491bc7-68ddfd29166mr6158103eaf.8.1776196529605;
 Tue, 14 Apr 2026 12:55:29 -0700 (PDT)
Date: Tue, 14 Apr 2026 19:55:27 +0000
In-Reply-To: <gsntpl7a694p.fsf@coltonlewis-kvm.c.googlers.com> (message from
 Colton Lewis on Thu, 15 Jan 2026 18:09:10 +0000)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsnt1pghgvv4.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v5 00/24] ARM64 PMU Partitioning
From: Colton Lewis <coltonlewis@google.com>
To: Colton Lewis <coltonlewis@google.com>
Cc: will@kernel.org, oupton@kernel.org, kvm@vger.kernel.org, 
	pbonzini@redhat.com, corbet@lwn.net, linux@armlinux.org.uk, 
	catalin.marinas@arm.com, maz@kernel.org, oliver.upton@linux.dev, 
	mizhang@google.com, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, mark.rutland@arm.com, shuah@kernel.org, 
	gankulkarni@os.amperecomputing.com, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Colton Lewis <coltonlewis@google.com> writes:

> Will Deacon <will@kernel.org> writes:

>> On Tue, Dec 09, 2025 at 03:00:59PM -0800, Oliver Upton wrote:
>>> On Tue, Dec 09, 2025 at 08:50:57PM +0000, Colton Lewis wrote:
>>> > This series creates a new PMU scheme on ARM, a partitioned PMU that
>>> > allows reserving a subset of counters for more direct guest access,
>>> > significantly reducing overhead. More details, including performance
>>> > benchmarks, can be read in the v1 cover letter linked below.
>>> >
>>> > An overview of what this series accomplishes was presented at KVM
>>> > Forum 2025. Slides [1] and video [2] are linked below.
>>> >
>>> > The long duration between v4 and v5 is due to time spent on this
>>> > project being monopolized preparing this feature for internal
>>> > production. As a result, there are too many improvements to fully list
>>> > here, but I will cover the notable ones.

>>> Thanks for reposting. I think there's still quite a bit of ground to
>>> cover on the KVM side of this, but I would definitely appreciate it if
>>> someone with more context on the perf side of things could chime in.

>>> Will, IIRC you had some thoughts around counter allocation, right?

>> Right, I was hoping that the host counter reservation could be more
>> dynamic than a cmdline option. Perf already has support for pinning
>> events to a CPU, so the concept of some counters being unavailable
>> shouldn't be too much for the driver to handle. You might just need to
>> create some fake pinned events so that perf code understands what is
>> happening.

> Thanks Will. I have a few followup questions:

> 1. Are you suggesting this be done whenever we enter a guest so the host
> always has access to the full range in host context? That would be the
> most dynamic.

> 2. How should we handle the possibility a real event already occupies a
> counter wanted by the guest? Is there a good way to create our fake
> pinned events then force a reschedule so perf moves the real events out
> of the way?

> 3. Is there an existing fake event type that tells perf not to touch
> hardware?

> 4. Can you point to any example code that already does something like
> this?

Thank you Will and Mark for meeting with me to discuss things in person.

Here's my main takeaways so the list can comment:

Will's initial idea doesn't work because there is no way for KVM to pin
counters in a way that takes priority over counters pinned by the host
and therefore guarantee reservation.

An alternate idea I am proposing is to call the perf core
sched_in/sched_out functionality during vcpu_load/vcpu_put when guest
counters need to be reserved/unreserved.

That means having perf vacate all the host counters temporarily,
modifying the arm_pmu.cntr_mask to add/remove the appropriate counters,
then having perf schedule all host events back on the new set. Perf is
capable of doing that without any significant changes.

This is simple and should work because arm_pmu.cntr_mask is already
accessible from the vcpu struct and modifying it is already how the
existing boot-time counter reservation works.

There are some tradeoffs to this approach that will need further
consideration. The first is how to handle event groups. Perf allows
events to be grouped such that they must all be scheduled in at once. If
the host has a larger group than the number of counters available while
the vcpu is loaded, then it simply won't be able to schedule that group
in for that time period. Another is whether it will be acceptable
performance-wise to put perf sched_in/sched_out in
vcpu_load/vcpu_put. I'm unsure how much delay that would add to those
paths.

Absent strong objections, I will be posting a series using this method.

Another idea that was not discussed that I had later is a middle
approach that is less dynamic but gives the user control over when the
perf sched_in/sched_out happens. Expose the existing boot-time parameter
as writable in sysfs and do the sched_out/modify mask/sched_in when that
is written rather than in vcpu_load.
