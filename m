Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C329C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 25 Jan 2022 17:29:31 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ADC9C49EB2;
	Tue, 25 Jan 2022 12:29:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pXuWxDJG4de8; Tue, 25 Jan 2022 12:29:29 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 95A6249EB4;
	Tue, 25 Jan 2022 12:29:29 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8611940B3B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Jan 2022 12:29:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Zk8tRSkPpjpc for <kvmarm@lists.cs.columbia.edu>;
 Tue, 25 Jan 2022 12:29:27 -0500 (EST)
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com
 [209.85.208.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6328A40AEB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Jan 2022 12:29:27 -0500 (EST)
Received: by mail-lj1-f169.google.com with SMTP id t7so9848695ljc.10
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Jan 2022 09:29:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=/hknxCIQs9L7yHre9W/YjWQp1r1IskMzEHUGv30wqmk=;
 b=H6YC+7gZK+rHzUwevbdt/gr7+NRBE96gYj+hnmNLXygphziRTMrkZmlwV21jXKJwcK
 crXaMzls4gcmtSu34YkvKWYmX1uoCTkkrFXp9J9puYZgNVD9MXN1OhIzOffyupTYY+fi
 lapyzofoU1EzSl3abb0hWQAOIry8cLaUz2+RUf2AUsRKbMDllI4Dxt6iRUkpbNnsySCS
 MFgamwMl5T4hgh//j8XQoSWnkzbEBMMPZv1y3RdWbjtSU27+Wm7WT2RQu2sjKrWPhi8u
 wbfQj64J3YZV87RPSTC/lpmSfFOSA6D/IsppUK835u8aX46KDj6yCdyZOYyWA3W+rQWI
 NlBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=/hknxCIQs9L7yHre9W/YjWQp1r1IskMzEHUGv30wqmk=;
 b=uW4mINESbtiJMyEc4MW1WhCWNtP35pEbfDFrX1zWwKF6C9U7ycEtIl34m8rsFqTtLX
 3JgmdNQP38UcUO9GD/Mov8k/AQOuQ9tMKhBunI6ygNC38dPAvITxW9xD746VLjOlJExp
 0Yw7emm/BnAdCUqNs5GAvdd+xlDk4dX0XwrOC57zuThCqGwU8ydIn/RE/d5lkrrguXlR
 Z5GtnH6BCMt+uxmpqoHu1Y4anivQtmJlza4TAGTZpUNFb0tUKbUMcpFWgmA5m3c+878i
 uV8PPPQrlMzHpk+9CBvFlRlSrQ+K0T3M9ZaPxw0Jx9iyjiHZHfnPWHL1gPlg5RHkUJTR
 0hTg==
X-Gm-Message-State: AOAM533IbJ6Pelnx5IIWY5kv8OTppKhwSPrADvzq5NsSz/YN6uFVW2gQ
 sCQlKPyxHCHoXD7PgdDlTIRDt6PurOznynbo1NFnpg==
X-Google-Smtp-Source: ABdhPJy9fZvaWGtBZz8tk4V1zsibsfK+5cWdGhGLbXd1O2iDMVIYgjWUUlbTawt6szEaW2PdkVfF1SxBUsCaH1/XpRo=
X-Received: by 2002:a2e:904f:: with SMTP id n15mr11656317ljg.275.1643131765866; 
 Tue, 25 Jan 2022 09:29:25 -0800 (PST)
MIME-Version: 1.0
References: <YSVhV+UIMY12u2PW@google.com> <87mtp5q3gx.wl-maz@kernel.org>
 <CAOQ_QshSaEm_cMYQfRTaXJwnVqeoN29rMLBej-snWd6_0HsgGw@mail.gmail.com>
 <87fsuxq049.wl-maz@kernel.org> <20210825150713.5rpwzm4grfn7akcw@gator.home>
 <CAOQ_QsgWiw9-BuGTUFpHqBw3simUaM4Tweb9y5_oz1UHdr4ELg@mail.gmail.com>
 <877dg8ppnt.wl-maz@kernel.org> <YSfiN3Xq1vUzHeap@google.com>
 <20210827074011.ci2kzo4cnlp3qz7h@gator.home>
 <CAOQ_Qsg2dKLLanSx6nMbC1Er9DSO3peLVEAJNvU1ZcRVmwaXgQ@mail.gmail.com>
 <87ilyitt6e.wl-maz@kernel.org>
 <CAOQ_QshfXEGL691_MOJn0YbL94fchrngP8vuFReCW-=5UQtNKQ@mail.gmail.com>
 <87lf3drmvp.wl-maz@kernel.org>
 <CAOQ_QsjVk9n7X9E76ycWBNguydPE0sVvywvKW0jJ_O58A0NJHg@mail.gmail.com>
 <CAJHc60wp4uCVQhigNrNxF3pPd_8RPHXQvK+gf7rSxCRfH6KwFg@mail.gmail.com>
 <875yq88app.wl-maz@kernel.org>
In-Reply-To: <875yq88app.wl-maz@kernel.org>
From: Oliver Upton <oupton@google.com>
Date: Tue, 25 Jan 2022 09:29:13 -0800
Message-ID: <CAOQ_QshL2MCc8-vkYRTDhtZXug20OnMg=qedhSGDrp_VUnX+5g@mail.gmail.com>
Subject: Re: KVM/arm64: Guest ABI changes do not appear rollback-safe
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, pshier@google.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Marc,

On Tue, Jan 25, 2022 at 12:46 AM Marc Zyngier <maz@kernel.org> wrote:
> > If I understand correctly, the original motivation for going with
> > pseudo-registers was to comply with QEMU, which uses KVM_GET_REG_LIST
> > and KVM_[GET|SET]_ONE_REG interface, but I'm guessing the VMMs doing
> > save/restore across migration might write the same values for every
> > vCPU.
>
> KVM currently restricts the vcpu features to be unified across vcpus,
> but that's only an implementation choice.

But that implementation choice has become ABI, no? How could support
for asymmetry be added without requiring userspace opt-in or breaking
existing VMMs that depend on feature unification?

> The ARM architecture doesn't
> mandate that these registers are all the same, and it isn't impossible
> that we'd allow for the feature set to become per-vcpu at some point
> in time. So this argument doesn't really hold.

Accessing per-VM state N times is bound to increase VM blackout time
during migrations ~linearly as the number of vCPUs in a VM increases,
since a VM scoped lock is necessary to serialize guest accesses. It
could be tolerable at present scale, but seems like in the future it
could become a real problem.

> Furthermore, compatibility with QEMU's save/restore model is
> essential, and AFAICT, there is no open source alternative.

Agree fundamentally, but I believe it is entirely reasonable to
require a userspace change to adopt a new KVM feature. Otherwise, we
may be trying to shoehorn new features into existing UAPI that may not
be a precise fit..

In order to cure the serialization mentioned above, two options are
top of mind: accessing the VM state with the VM FD or informing
userspace that a set of registers need only be written once for an
entire VM. If we add support for asymmetry later down the road, that
would become an opt-in such that userspace will do the access
per-vCPU.

> A device means yet another configuration and migration API. Don't you
> think we have enough of those? The complexity of KVM/arm64 userspace
> API is already insane, and extremely fragile. Adding to it will be a
> validation nightmare (it already is, and I don't see anyone actively
> helping with it).

It seems equally fragile to introduce VM-wide serialization to vCPU
UAPI that we know is in the live migration critical path for _any_
VMM. Without requiring userspace changes for all the new widgets under
discussion we're effectively forcing VMMs to do something suboptimal.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
