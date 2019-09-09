Return-Path: <SRS0=3K2b=XE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E0B4C4740C
	for <kvmarm@archiver.kernel.org>; Mon,  9 Sep 2019 15:56:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AB58E20863
	for <kvmarm@archiver.kernel.org>; Mon,  9 Sep 2019 15:56:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="IjGuVdyh"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AB58E20863
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 093A14A528;
	Mon,  9 Sep 2019 11:56:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0ez5gXxb-aVN; Mon,  9 Sep 2019 11:56:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C57704A531;
	Mon,  9 Sep 2019 11:56:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E21D64A52D
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Sep 2019 11:56:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Yc3-2BUeaQ78 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Sep 2019 11:56:34 -0400 (EDT)
Received: from mail-ot1-f65.google.com (mail-ot1-f65.google.com
 [209.85.210.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CA6714A521
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Sep 2019 11:56:34 -0400 (EDT)
Received: by mail-ot1-f65.google.com with SMTP id 67so12923755oto.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 Sep 2019 08:56:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=kQKpAgCR0aWCUsHchRbJumhQq4BDu43empvLhB4T6fI=;
 b=IjGuVdyhihsn0b2oYLNf4y7K69+X5aGEmAFSdm+1q0Kll52046kdiPV2LPXnxRzqTk
 foFxeVH98++bVgffBOr5uA0D8e72l42msAAIgxqS250eBsUVorYHMEiCb5QbU7KhvetI
 CIoYbFPIZVSUAdWVOSO4QJKBdRNBCOMG37mqOCKwdYP7ujjVSP2XNi/wftjSqM46UKsF
 PcHNNrEbbA2V+dozh6tkDwaB3/vc2yK1mFnvw5MQAmJf14oKrmatelLOZFDK/ihq5ilB
 w5cI5ClKRiFHrc+O95zu9WVvBymSNNT/jZaMHVC6dNkeDRahg6RN0fM7/nd7UOxdpTVH
 hj5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=kQKpAgCR0aWCUsHchRbJumhQq4BDu43empvLhB4T6fI=;
 b=oWaYfEA389DbgBtx3BP+EnpqvkiDNwrmQTZmyEImfYqvXKdBTo5lwZfTI7om5qd9Dm
 YbrpdfH1kMPiaF1z4Qh3qMDfcJOnBMfXyfXPpmv8tziB23JoJy7ruxVPy/095ST+mm7o
 6ptYLClLfTFPFRhh1oPedi/+WVDFbOlKvK9ChiURE5frbHbdUKL+Opvu3L5uoircc6lV
 8JOh9p6VAICG81bU1cLOt//JAXDE2ri2dW5QH/BEaCPwk8vMPymAdPutX860c0qzeNno
 xlbQ5Z5JOtrLLrl9rLsjCWt+Y4T170hX5508/eU8bEJ7vGNilfafEd6/1TwuqtrKQQs4
 LWtw==
X-Gm-Message-State: APjAAAXkJitrAIufimBOl7URIWFBrRqCML1Z5bu+qOOEWfU3X9dKK2/r
 +FTptT7MXbkkFmlM4xpiua7Ciyd5/8SFtOEqeDIQBw==
X-Google-Smtp-Source: APXvYqzbc9c18AQCh76zKydtjHclhprX3nwiBJCVCBrHjfBy36NDDmORyT9T+dl4742NmvQzsZpn5WqNHStM991/rRg=
X-Received: by 2002:a9d:5e11:: with SMTP id d17mr20660650oti.135.1568044594249; 
 Mon, 09 Sep 2019 08:56:34 -0700 (PDT)
MIME-Version: 1.0
References: <20190909121337.27287-1-christoffer.dall@arm.com>
 <20190909121337.27287-3-christoffer.dall@arm.com>
 <CAFEAcA8WcQNJV27q5WJ-SMhOyjFZyh1Pz7H7duK6zW1wiAvqKQ@mail.gmail.com>
 <20190909151631.GA26449@lvm>
In-Reply-To: <20190909151631.GA26449@lvm>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Mon, 9 Sep 2019 16:56:23 +0100
Message-ID: <CAFEAcA-F3YLEQgKAvfbyGGYdzs_wYPz+QMuxk4qZd_oeU-_PBA@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: arm/arm64: Allow user injection of external data
 aborts
To: Christoffer Dall <christoffer.dall@arm.com>
Cc: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Marc Zyngier <maz@kernel.org>, Stefan Hajnoczi <stefanha@redhat.com>,
 Heinrich Schuchardt <xypron.glpk@gmx.de>, kvmarm@lists.cs.columbia.edu,
 arm-mail-list <linux-arm-kernel@lists.infradead.org>
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

On Mon, 9 Sep 2019 at 16:16, Christoffer Dall <christoffer.dall@arm.com> wrote:
>
> On Mon, Sep 09, 2019 at 01:32:46PM +0100, Peter Maydell wrote:
> > This API seems to be missing support for userspace to specify
> > whether the ESR_ELx for the guest should have the EA bit set
> > (and more generally other syndrome/fault status bits). I think
> > if we have an API for "KVM_EXIT_MMIO but the access failed"
> > then it should either (a) be architecture agnostic, since
> > pretty much any architecture might have a concept of "access
> > gave some bus-error-type failure" and it would be nice if userspace
> > didn't have to special case them all in arch-specific code,
> > or (b) have the same flexibility for specifying exactly what
> > kind of fault as the architecture does. This sort of seems to
> > fall between two stools. (My ideal for KVM_EXIT_MMIO faults
> > would be a generic API which included space for optional
> > arch-specific info, which for Arm would pretty much just be
> > the EA bit.)
>
> I'm not sure I understand exactly what would be improved by making this
> either more architecture speific or more architecture generic.  The
> EA bit will always be set, that's why the field is called
> 'ext_dabt_pending'.

ESR_EL1.EA doesn't mean "this is an external abort". It means
"given that this is an external abort as indicated by ESR_EL1.DFSC,
specify the external abort type". Traditionally this is 0 for
an AXI bus Decode error ("interconnect says there's nothing there")
and 1 for a Slave error ("there's something there but it told us
to go away"), though architecturally it's specified as impdef
because not everybody uses AXI. In QEMU we track the difference
between these two things and for TCG will raise external aborts
with the correct EA bit value.

> I thought as per the previous discussion, that we were specifically
> trying to avoid userspace emulating the exception in detail, so I
> designed this to provide the minimal effort API for userspace.
>
> Since we already have an architecture specific ioctl, kvm_vcpu_events, I
> don't think we're painting ourselves into a corner by using that.  Is a
> natural consequence of what you're saying not that we should try to make
> that whole call architecture generic?
>
> Unless we already have specific examples of how other architectures
> would want to use something like this, and given the impact of this
> patch, I'm not sure it's worth trying to speculate about that.

In QEMU, use of a generic API would look something like
this in kvm-all.c:

        case KVM_EXIT_MMIO:
            DPRINTF("handle_mmio\n");
            /* Called outside BQL */
            MemTxResult res;

            res = address_space_rw(&address_space_memory,
                                   run->mmio.phys_addr, attrs,
                                   run->mmio.data,
                                   run->mmio.len,
                                   run->mmio.is_write);
            if (res != MEMTX_OK) {
                /* tell the kernel the access failed, eg
                 * by updating the kvm_run struct to say so
                 */
            } else {
                /* access passed, we have updated the kvm_run
                 * struct's mmio subfield, proceed as usual
                 */
            }
            ret = 0;
            break;

[this is exactly the current QEMU code except that today
we throw away the 'res' that tells us if the transaction
succeeded because we have no way to report it to KVM and
effectively always RAZ/WI the access.]

This is nice because you don't need anything here that has to do
"bail out to architecture specific handling of anything",
you just say "nope, the access failed", and let the kernel handle
that however the CPU would handle it. It just immediately works
for all architectures on the userspace side (assuming the kernel
defaults to not actually trying to report an abort to the guest
if nobody's implemented that on the kernel side, which is exactly
what happens today where there's no way to report the error for
any architecture).
The downside is that you lose the ability to be more specific about
architecture-specific fine distinctions like decode errors vs slave
errors, though.

Or you could have an arm-specific API that does care about
fine details like the EA bit (and maybe also other ESR_ELx
fields); that has the downside that userspace needs to
make the handling of error returns from "handle this MMIO
access" architecture specific, but you get architecture-specific
benefits as a result. (Preferably the architecture-specific
APIs should at least be basically the same, eg same ioctl
or same bit of the kvm_run struct being updated with some parts
being arch-specific data, rather than 3 different mechanisms.)

Having an API that is architecture specific but doesn't actually
let you define any of the architecture-specific aspects of
what the abort might imply seems like the worst of both worlds.
If all we can say is "this aborted" then we might as well have
the API be generic.

thanks
-- PMM
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
