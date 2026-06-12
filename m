Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CEC9365A13
	for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 14:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781275243; cv=none; b=qgZuveh0Radj7fy33fl7buuyylDatSisb1wpXHUcOmPH2jl+qK5C/w4RjlN5J0ZIf9VunAKoXDkZgFyvCJfEIvGzw/XRZXuk0cl0/z/HJlKE2XOUtuNONBfVAQzsrQTnObRi27oFyyQzdm00Y5He3g5lCZwBGDkaE+kUCXKSbMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781275243; c=relaxed/simple;
	bh=xYohhk2PXNLyT0KACdOrWgRqYUCLE0x2yCL5cAP7u/A=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=R6rbxdZ5Krcc7Pn5n66kr4fvVe39Kg25OQFj0KGPyJf9Dk48x7bu82SlQJuj1EZCLK9wE6gLHE3jn5TMx9ZJJdv+7EKFverUCUb1UXeBI6E2lEcamyXoiIYmWM5L9LEe+xOfT4DDuKOt9fXPuD8meYWgAQz4Egu7tC97NbPFrtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n3femVT6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n3femVT6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5BAB1F000E9;
	Fri, 12 Jun 2026 14:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781275242;
	bh=MVDbI1KFUwS8jICIk49W9Yw4T34Mn7grZ9GJIyuwRz4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=n3femVT6HRamVJhWYGTD00EWkIJj/ULOIT3HKHcJXEOpR/LMj19k+wib8GPjnI1R2
	 w8EFZdc/wkjwEOnzS4pMJ3NSdWqzApmbUb1PFO+tHKmTZos4z218egc77LVX1A+3w4
	 V5fOyblYmNRmsdFZl99bnxGXfaWwfOfhIOWqFw4YjTL1/HfUEmmxv+8grxfFnZx0PQ
	 DMMdJ4z3OCMk5VOGkIQZHz9OQpuSh5Bqb6v76ZbHUNSpjjI7d3bUbibP6Ao/f51jop
	 G1NfKqE9GZuWZT8dadY/d/NZJo9d7n4M4+cEQJUdL3AjzBa55WzvKboTFcM/aNu0L1
	 Kt4m8J4E3ZUrw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 3/4] tracing/remotes: Add
 REMOTE_EVENT_CUSTOM_PRINTK() helper
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vincent Donnefort" <vdonnefort@google.com>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260612142245.1015744-4-vdonnefort@google.com>
References: <20260612142245.1015744-4-vdonnefort@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 12 Jun 2026 14:40:41 +0000
Message-Id: <20260612144041.C5BAB1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Missing payload length validation and broken event pointer arithme=
tic causing Out-of-Bounds reads.
--

commit 08a76348182599b6627f69fa9a3f00bf4080d17a
Author: Vincent Donnefort <vdonnefort@google.com>

tracing/remotes: Add REMOTE_EVENT_CUSTOM_PRINTK() helper

This commit introduces a REMOTE_EVENT_CUSTOM_PRINTK() macro where the
__printk argument can be a function. This intends to support the creation
of a dynamic "printk" event for the arm64 nVHE/pKVM hypervisor.

> diff --git a/include/trace/define_remote_events.h b/include/trace/define_=
remote_events.h
> index 676e803dc144d..4f4d58e37b84b 100644
> --- a/include/trace/define_remote_events.h
> +++ b/include/trace/define_remote_events.h
[ ... ]
> +#define REMOTE_EVENT_PRINT_FUNC(__name, __printk)					\
>  	static void remote_event_print_##__name(void *evt, struct trace_seq *se=
q)	\
>  	{										\
>  		struct remote_event_format_##__name __maybe_unused *__entry =3D evt;	\

[Severity: High]
Does this direct cast of the evt payload pointer lack length validation?

It appears there is no check to ensure the event length from the ring
buffer is large enough to hold the format structure before casting.

Additionally, in the final state of the series, is there an issue
calculating the number of arguments in __hyp_trace_printk()?

arch/arm64/kvm/hyp_trace.c:__hyp_trace_printk() {
    struct ring_buffer_event *evt =3D (void *)entry - RB_EVNT_HDR_SIZE;
    ...
    nr_args =3D (ring_buffer_event_length(evt) - offsetof(struct remote_eve=
nt_format_hyp_printk, args)) / sizeof(entry->args[0]);
}

Because the hypervisor uses simple_ring_buffer, it writes events with
type_len =3D 0 (indicating the length is stored in array[0]). Consequently,
ring_buffer_event_data() skips the 4-byte length field, meaning the entry
payload pointer actually points to &rb_event->array[1].

Subtracting RB_EVNT_HDR_SIZE (4 bytes) yields a pointer to
&rb_event->array[0], not the actual event header.=20

When ring_buffer_event_length(evt) is called on this misaligned pointer,
could it interpret the original length or the payload's fmt_id field
as the type_len header?

This would lead to highly incorrect length calculations (e.g., treating
an event size of 20 as 64 bytes), guaranteeing that __hyp_trace_printk
will either silently drop arguments or read arguments out-of-bounds.=20

If the event is near the end of a mapped page, could reading past
these boundaries trigger a host kernel panic?

>  		trace_seq_puts(seq, #__name);						\
> -		remote_printk(__printk);						\
> +		__printk;								\
>  	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260612142245.1015=
744-1-vdonnefort@google.com?part=3D3
