Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.188
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794814941;
	b=Ca9Ys1CXPv55AKOXEDRsD15f5V38Lh0q+8+BPPg2gGg34AXG6WlHQGPGOIbil2h0KOJB
	 O0t8ukAMpcXkrAh5lfwn7tCij3xMbYMLkTOOxVGUPVuB85ABiTNU9znSyVtgXn8fXyC0i
	 Ep+ZGYNaS4hNY9UpiJ+ekUufxY72F4rxXam/67Dn/JdyiXsPSfEcJ9XwTr2TW6CBUj7XJ
	 F2K8ZRWYB2OwfrAN4eU8nNUCJOvLmInl8K3Unla5XvHBFS8r9jrooFXCB6S5ghZ80cfJI
	 ESf2cQ7dxcpXLjpWagHNMQ4U9YBQf15ykCiZZ7X7F3kbPe2JVxxtXYAj7eNInF2YJsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794814941;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=Sqeef6VWXCGPSprL2sUdbvrAz/Iy/oSXdyGiMisPWE4=;
	b=B+NO10xniF37T28xy91fRnUQLg/0+FJkdnZQ/S7VKJ10m1+N6Jlx6yUf5LT9LXKXDg6x
	 3QIO2rhrisFiS3SW2SYWPVBI09IwSAYvHn420icf1olHYq3gij+UR4N61TW9Iwpz1cUSe
	 E9o9a8Yw4nddLI7ENnwrfXBVRWK1qENcjIDJAaWG7XECz/3j4ymtf3yV9yF/+iosLpNCD
	 wz15X0NQYkejOLS7+4TuW/BfTx1l0WOlIGv3cKltOjAp17WUg6mmJNayz+PI/1vxWgfbk
	 Y3Z3pEdqN+R3/M+jmoDp/JvHHuPbo+Jd3E5mABsvYzXX+IvmP4VGk5tI+FyMlpbwA3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=V+bQ2qC9;
	arc=none smtp.remote-ip=95.215.58.188
Received: from mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CAA4606A32C
	for <kvmarm@lists.linux.dev>; Mon, 16 Nov 2026 07:42:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6CAA4606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=V+bQ2qC9
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=4boBAffMzoVHjAgWiSv2kJlP8mtRBwtsuJLv1o8lqGk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794814938; v=1; x=1795419738;
 b=V+bQ2qC9kaZI/An86/ujiZDKM5VZRKsxKogoGYXdmtN43zGGV+qwSzalHCfOSYoQkm0+uxoY
 2Yf48V3kk7sGWYPvvlqAlfuvhDRBKRMcOzj3pP8r4OTNDdPslm0j0GXm4OeVxIy3l5mmZXmFsWB
 I0E2YsAvWXI8d9v3D8tVrt0I=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id cd14d68dc4d07867;
	Mon, 16 Nov 2026 07:42:18 +0000
X-Mizu-Trace-ID: cd14d68dc4d07867
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5be58ad9600so6407e87.0
        for <kvmarm@lists.linux.dev>; Sun, 15 Nov 2026 23:42:13 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErEt5VlIgDTQs0iuXvUxjGS2uuUA0yo/TtThHd42udOUksX3AwTXcx+7LHAYDT6xYOuOGhsiyPk=@lists.linux.dev
X-Gm-Message-State: APuU4Z8na5ZX3Kt5tB9zU8gSQokb3MW3eTUQlruSESEdIJ3cIxtZihPJ
	UbW8qDiYl93qs5XQSZiZaf1LzvdiGIjdlMgD+n8WkkUEmIGk0IDYl3dpkBsqiy/l/l9i3u664nB
	X03a2ZSPoGYmCjDVzvch7E8b3ZDIsbe4rgcgFtpUR
X-Received: by 2002:a05:6512:1244:b0:5c1:4bd2:df42 with SMTP id
 2adb3069b0e04-5c17e452300mr135874e87.12.1794814932262; Sun, 15 Nov 2026
 23:42:12 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261113081934.1715497-1-fuad.tabba@linux.dev> <87jymf8m1z.wl-maz@kernel.org>
In-Reply-To: <87jymf8m1z.wl-maz@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 16 Nov 2026 07:41:35 +0000
X-Gmail-Original-Message-ID: <CA+EHjTyhBd1rNqr2DV7kAdbtonEW8a+euJHMMsD-UsD9_-5S8g@mail.gmail.com>
X-Gm-Features: Aa3M54o6cnejirjhEwUOGDdCwRplzokz4vB083Z4FAIDONp5f_S3HfgryjrtL68
Message-ID: <CA+EHjTyhBd1rNqr2DV7kAdbtonEW8a+euJHMMsD-UsD9_-5S8g@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Keep firmware Spectre-v4 mitigation on for
 protected guests
To: Marc Zyngier <maz@kernel.org>
Cc: oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	mark.rutland@arm.com, vdonnefort@google.com, ryan.roberts@arm.com, 
	qperret@google.com, steven.price@arm.com
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Sat, 14 Nov 2026 15:33:44 +0000, Marc Zyngier <maz@kernel.org> wrote:
[...]
> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
[...]
> > @@ -30,6 +31,8 @@
> >
> >  DEFINE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
> >
> > +static DEFINE_PER_CPU(bool, host_ssbd_disabled);
> > +
>
> Why do we need yet another set of per-CPU booleans to track the host
> state that is supposed to be stored in kvm_host_data? We already have
> a metric bazillion of flags for any odd state tracking, and I really
> can't see why this should be an exception.

I'll use a kvm_host_data flag in v2.

[...]
> > @@ -940,6 +943,17 @@ DEFINE_KVM_HOST_HCALL(int, __kvm_vcpu_run, struct kvm_vcpu __kern *, vcpu)
> >                          return ret;
> >                  }
> >
> > +                /*
> > +                 * Firmware Spectre-v4 mitigation can be advertised to a
> > +                 * protected guest as permanent. The host kernel runs with it
> > +                 * enabled, so nothing is restored on exit.
>
> I don't understand this. If the host is supposed to run with the
> mitigation enabled, how did we get here with the mitigation disabled?
> It's not like we can get here directly from userspace...
>
> So either the reasoning in the comment is wrong (and therefore needs
> fixing), or this is a buggy (malicious?) host that tries to trick the
> hypervisor (and then I question whether we should even try to continue
> running the guest).

It's the second. The host kernel enables the mitigation on every entry
from userspace, so only a misbehaving host gets here with it disabled.
I'll say so in the comment.

I had EL2 enable it again so that the NOT_REQUIRED it returns to the
guest holds whatever the host does, but failing the run does that too.
I'll do that in v2, like the SVCR check above.

[...]
> > @@ -1671,6 +1685,12 @@ static void handle_host_smc(struct kvm_cpu_context *host_ctxt)
> >                  goto exit_skip_instr;
> >          }
> >
> > +        if (func_id == ARM_SMCCC_ARCH_WORKAROUND_2) {
> > +                /* Drop the hints, so that the firmware decodes the ID as EL2 did. */
> > +                cpu_reg(host_ctxt, 0) = func_id;
> > +                __this_cpu_write(host_ssbd_disabled, !lower_32_bits(cpu_reg(host_ctxt, 1)));
> > +        }
> > +
>
> This should be pushed into default_host_smc_handler() rather than left
> dangling here (it is pretty obvious that it has nothing to do with
> PSCI or FFA).

I put it there since that's where the function ID is decoded, but I'll
move it into default_host_smc_handler() and pass the ID in.

Cheers,
/fuad
