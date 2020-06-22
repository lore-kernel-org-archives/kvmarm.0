Return-Path: <SRS0=1gKC=AD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A579C433DF
	for <kvmarm@archiver.kernel.org>; Mon, 22 Jun 2020 10:39:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B56A1206FA
	for <kvmarm@archiver.kernel.org>; Mon, 22 Jun 2020 10:39:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="S2oqL5OT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B56A1206FA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6BFB44B09C;
	Mon, 22 Jun 2020 06:39:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Iw7DLa+R3+7M; Mon, 22 Jun 2020 06:39:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 42FC44B0C8;
	Mon, 22 Jun 2020 06:39:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F55F4AEE2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jun 2020 06:39:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id f33ESx-9JXku for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Jun 2020 06:39:52 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6EC8D4AEDC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jun 2020 06:39:52 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 80FC4206FA;
 Mon, 22 Jun 2020 10:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1592822391;
 bh=dgm7kjeoShRXdQis73vvUuIZrsj5DaDNqgHFNWcsw3Q=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=S2oqL5OT+ITpyFdrgk4+bxcZAFW/FLK52PcA/biEqraUAECNSX51/R5fzxvk2f7WB
 UZAqUvp6800mgPzpJVP1UgHxUjFIhx+Vr4r85xUfOyDqkQFtKx5pQWnolc5lfZtUZ3
 +aVaTL+FXQM5zI0NYlNCAtqiefaCGGTkIjQrkO6E=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jnJrh-005Hny-Qi; Mon, 22 Jun 2020 11:39:50 +0100
MIME-Version: 1.0
Date: Mon, 22 Jun 2020 11:39:49 +0100
From: Marc Zyngier <maz@kernel.org>
To: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 2/4] arm64/x86: KVM: Introduce steal time cap
In-Reply-To: <20200622103146.fwtr7z3l3mnq4foh@kamzik.brq.redhat.com>
References: <20200619184629.58653-1-drjones@redhat.com>
 <20200619184629.58653-3-drjones@redhat.com>
 <5b1e895dc0c80bef3c0653894e2358cf@kernel.org>
 <20200622084110.uosiqx3oy22lremu@kamzik.brq.redhat.com>
 <5a52210e5f123d52459f15c594e77bad@kernel.org>
 <20200622103146.fwtr7z3l3mnq4foh@kamzik.brq.redhat.com>
User-Agent: Roundcube Webmail/1.4.5
Message-ID: <7118fcbe911bdb30374b400dc01ca8de@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: drjones@redhat.com, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com, steven.price@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 steven.price@arm.com
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2020-06-22 11:31, Andrew Jones wrote:
> On Mon, Jun 22, 2020 at 10:51:47AM +0100, Marc Zyngier wrote:
>> On 2020-06-22 09:41, Andrew Jones wrote:
>> > On Mon, Jun 22, 2020 at 09:20:02AM +0100, Marc Zyngier wrote:
>> > > Hi Andrew,
>> > >
>> > > On 2020-06-19 19:46, Andrew Jones wrote:
>> > > > arm64 requires a vcpu fd (KVM_HAS_DEVICE_ATTR vcpu ioctl) to probe
>> > > > support for steal time. However this is unnecessary and complicates
>> > > > userspace (userspace may prefer delaying vcpu creation until after
>> > > > feature probing). Since probing steal time only requires a KVM fd,
>> > > > we introduce a cap that can be checked.
>> > >
>> > > So this is purely an API convenience, right? You want a way to
>> > > identify the presence of steal time accounting without having to
>> > > create a vcpu? It would have been nice to have this requirement
>> > > before we merged this code :-(.
>> >
>> > Yes. I wish I had considered it more closely when I was reviewing the
>> > patches. And, I believe we have yet another user interface issue that
>> > I'm looking at now. Without the VCPU feature bit I'm not sure how easy
>> > it will be for a migration to fail when attempting to migrate from a
>> > host
>> > with steal-time enabled to one that does not support steal-time. So it's
>> > starting to look like steal-time should have followed the pmu pattern
>> > completely, not just the vcpu device ioctl part.
>> 
>> Should we consider disabling steal time altogether until this is 
>> worked out?
> 
> I think we can leave it alone and just try to resolve it before merging
> QEMU patches (which I'm working on now). It doesn't look like kvmtool 
> or
> rust-vmm (the only other two KVM userspaces I'm paying some attention 
> to)
> do anything with steal-time yet, so they won't notice. And, I'm not 
> sure
> disabling steal-time for any other userspaces is better than just 
> trying
> to keep them working the best we can while improving the uapi.

Is it only migration that is affected? Or do you see issues that would
affect non-migrating userspace?

[...]

>> Accepting the pvtime attributes (setting up the per-vcpu area) has two
>> effects: we promise both the guest and userspace that we will provide
>> the guest with steal time. By not checking sched_info_on(), we lie to
>> both, with potential consequences. It really feels like a bug.
> 
> Yes, I agree now. Again, following the pmu pattern looks best here. The
> pmu will report that it doesn't have the attr support when its 
> underlying
> kernel support (perf counters) doesn't exist. That's a direct analogy 
> with
> steal-time relying on sched_info_on().

Indeed. I'd be happy to take a fix early if you can spin one.

> I'll work up another version of this series doing that, but before 
> posting
> I'll look at the migration issue a bit more and likely post something 
> for
> that as well.

OK. I'll park this series for now.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
