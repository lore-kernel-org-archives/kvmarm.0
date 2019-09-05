Return-Path: <SRS0=E5f7=XA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34E0FC3A5A5
	for <kvmarm@archiver.kernel.org>; Thu,  5 Sep 2019 08:48:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 949D220820
	for <kvmarm@archiver.kernel.org>; Thu,  5 Sep 2019 08:48:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="VjwV1nM5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 949D220820
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0EC1C4A594;
	Thu,  5 Sep 2019 04:48:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmx.net
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id buSHEIpZqPmS; Thu,  5 Sep 2019 04:48:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CFF1E4A554;
	Thu,  5 Sep 2019 04:48:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 82D0E4A525
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Sep 2019 04:48:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dbHrtyNoRo52 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 Sep 2019 04:48:47 -0400 (EDT)
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 230CA4A522
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Sep 2019 04:48:46 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
 s=badeba3b8450; t=1567673320;
 bh=shlqMDrOPL2mFQcbMrl3Dmhn8G7cJYEwFhacKBjb9uk=;
 h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
 b=VjwV1nM5HPPWdBdmj0Bw9BD8tUUlZ3FOcTPMicBGoDUUnhHz7zrG+LwuLnUP0e/gU
 dOeF2C6L3cHdCPF6BHsXylSaC6O1JAdQGFE6BO9GRTEQ5jCFZTHe/WLXaENUJ4C+IP
 vduDGfY29gfawgXia3MkfAxYxaW3xgdvtTLTWTRM=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.123.51] ([84.118.159.3]) by mail.gmx.com (mrgmx102
 [212.227.17.168]) with ESMTPSA (Nemesis) id 0MMpYB-1i5Wzw3GSl-008ZJA; Thu, 05
 Sep 2019 10:48:39 +0200
Subject: Re: [PATCH 1/1] KVM: inject data abort if instruction cannot be
 decoded
To: Peter Maydell <peter.maydell@linaro.org>, Marc Zyngier <maz@kernel.org>
References: <20190904180736.29009-1-xypron.glpk@gmx.de>
 <86r24vrwyh.wl-maz@kernel.org>
 <CAFEAcA-mc6cLmRGdGNOBR0PC1f_VBjvTdAL6xYtKjApx3NoPgQ@mail.gmail.com>
From: Heinrich Schuchardt <xypron.glpk@gmx.de>
Message-ID: <a65029ac-a10d-35cb-97a1-70a786db9ddf@gmx.de>
Date: Thu, 5 Sep 2019 10:48:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAFEAcA-mc6cLmRGdGNOBR0PC1f_VBjvTdAL6xYtKjApx3NoPgQ@mail.gmail.com>
Content-Language: en-US
X-Provags-ID: V03:K1:KxYUVwdwyV1sgcHyPJ9Y1C3193d8A9orrGeFRwziwaWw1v+3X7Y
 O5NZp0DxxFeMqvZaV1/ZSIEBlpH0lCwoSIMdq5vrOPkMIpFNv2P8t1eqsWMyDavj6V46I7z
 GaUVCnRKvOtVMmaNJ7uSBLld0LnIDj0ax5WeS1wc7/GBosx6Aq6qm1/ha9OluHZq3GOZ0SB
 jtuxt32IhbCU1Du6eZ2ww==
X-UI-Out-Filterresults: notjunk:1;V03:K0:zbIUV7C6j3s=:lOzWjIAKXP73Hcz0gQnMG+
 PNSuwte4nimIq7L1qzyDL4veP4IPcMkxTz/I0DyBEE+QojSiD6gYTMPFrgvzGkOhP+J9AA0KM
 39OW2AQn0sLZV7RtAiyCxo7fs+YQjVv9V0sP6zsEmMd2TkZOSk6/Q1IRGIecWIy9sA8FTB/mE
 rLdpkApY5zvBda8z+MZGCwpN/a+uaTwmhiONGlUTBqcyyBbQBBM0RnM8rq60HPkXVoHQB5K7X
 gUzfJjiDlo8pp6qbotmMlpYChLCtcYBdCzAChFsrftHaedexzPRVWOSIRKnFe003ig2APn62G
 YVifG4NqQkmtuhR5mWmzysmtwYKvzQoa9pT0Cnj75iC2jbpSumfuxLANat0tO0LtmKsThbeXC
 kQ/BypnVguqmZOs77gh4E17Inw6Z2f/6bOfUUYTrcEHMasl6Qh4OEbfxJhGj09yyoeCFupzJD
 om7AqNFhmceqxOYRDTZQD2OwbfHC2rAGyRyrNG6Ero8hWVVsv/2HqloW5VXgghXDw9NeK26fo
 JqMDh0ygkyAnCTZ67CZa0ROxzM0rFj7kbPogjQ+Ha1OaVTpqNHdIEKhM4QfQNx6RMGrpOHAhL
 lt9srD9U2VXGIePTlU9USGP1B7uBZS3xE8sxykjlZtbrRn24qc2YQfPM9OP/++hogYj88Bxen
 IKX69orI2ng3no6Zw0a8dfbf8KFMEhEqUOolgT4T/tBvpNlKu9giMnlqM6VTY3I6R+8JYMZ4U
 D6e+8M6JQQamt/7bujo1UVvb4pA7RUn7yyysD3BeteEtTCrzvsEmcD2NiRpcSzW3Xa6RQzzuH
 w2lgV0oBCj6tbQgvPcpdq17PPBS3QLcSELQ7YSCgs4kHPW6y9e/DVhH0B+pfsp6jhmcrLER32
 W7Wdga5VmXMijVgR64OkBPMZRGrO+QBJHk4hmPjgDfbTc6qppRp2xcEBBuxIKdos45dS7FWxw
 Vu4vhcPRaE7nhEuW4+mbKKn1+EPXK/3Mrue1e03HnZY2kqC1rNmVxJKFG2lFLwoNMxX8rTanv
 0AwymqKXVItoqqHIU1o4haYjA4gwGouI6I/iqnvw6MbCBDa/Noanb922sHCZQmiNCctQhxXnG
 N7rwYxkh/8mKDuCTA4oY0+/bBKlNsTo2P8i4o6aqQ/iSQbQnk3Ll6L/7uWRukS8e5N4Z92T6G
 dghUzZTzeNknRCurHvlvOD3ew5sRt7N860zt9vjHGP9oZ5FrvqrcusOS8hZ6q513cnza+1ZDW
 JROa5SVVQse+umGt0
Cc: =?UTF-8?Q?Daniel_P_=2e_Berrang=c3=a9?= <berrange@redhat.com>,
 lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Stefan Hajnoczi <stefanha@redhat.com>, kvmarm@lists.cs.columbia.edu,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 9/5/19 10:16 AM, Peter Maydell wrote:
> On Thu, 5 Sep 2019 at 09:04, Marc Zyngier <maz@kernel.org> wrote:
>> How can you tell that the access would fault? You have no idea at that
>> stage (the kernel doesn't know about the MMIO ranges that userspace
>> handles). All you know is that you're faced with a memory access that
>> you cannot emulate in the kernel. Injecting a data abort at that stage
>> is not something that the architecture allows.
>
> To be fair, locking up the whole CPU (which is effectively
> what the kvm_err/ENOSYS is going to do to the VM) isn't
> something the architecture allows either :-)
>
>> Of course, the best thing would be to actually fix the guest so that
>> it doesn't use non-emulatable MMIO accesses. In general, that the sign
>> of a bug in low-level accessors.
>
> This is true, but the problem is that barfing out to userspace
> makes it harder to debug the guest because it means that
> the VM is immediately destroyed, whereas AIUI if we
> inject some kind of exception then (assuming you're set up
> to do kernel-debug via gdbstub) you can actually examine
> the offending guest code with a debugger because at least
> your VM is still around to inspect...

Stopping the CPU and debugging is not what I am interested in. I want
the QEMU guest to be able to react to an incorrect memory access.

Imagine Apollo 11's computer not restarting when hitting an exception.
They would never have reached the moon. - I think allowing an emulation
guest to react to an exception, e.g. by resetting, is a necessity.

In my case U-Boot as a guest creates an output like the one below when a
data abort occurs:

"Synchronous Abort" handler, esr 0x02000000
elr: fffffffffdeac19c lr : fffffffffdeac19c (reloc)
elr: 000000007ddd719c lr : 000000007ddd719c
x0 : 0000000000000000 x1 : 000000007ffbc000
x2 : 000000000000000a x3 : 000000007ffbcd80
x4 : 0000000000002800 x5 : 000000007ffbcdb0
x6 : 0000000000000001 x7 : 000000007eef8b80
x8 : 000000000000003f x9 : 0000000000000004
x10: 0000000000000001 x11: 000000000000000d
x12: 0000000000000006 x13: 000000000001869f
x14: 0000000047f00000 x15: 0000000000000000
x16: 000000007ff5b194 x17: 0000000000000000
x18: 0000000000000000 x19: 000000007ffbcd30
x20: 0000000000000000 x21: 000000007ffeb000
x22: 0000000000000009 x23: 000000007eef5cf0
x24: 0000000000000000 x25: 000000007ffa7806
x26: 000000007ffa7834 x27: 0000000000000024
x28: 000000007dddd040 x29: 000000007ede9990

UEFI image [0x000000007ddd7000:0x000000007ddd749f] pc=0x19c '/bug.efi'
Resetting CPU ...

With this information I see that the problem occurred at 0x019C from the
start of the loaded binary bug.efi. Next thing is to look at the map
file of bug.efi to find out in which instruction the problem occurred.

After providing the dump U-Boot continues to reset the system.

When U-Boot is running the EDK II SCT (a test suite for UEFI firmware),
SCT will log that a restart occurred (indicating that a test failed) and
continue to run the next test.

Best regards

Heinrich
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
