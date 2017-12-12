From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v2 07/19] arm64: insn: Add encoder for bitwise operations
 using litterals
Date: Tue, 12 Dec 2017 23:40:54 +0000
Message-ID: <CAFEAcA8_+2JA2m2DjZpkEhJC9QPRpgcwrZ0gYxtGV+Hep4e8GA@mail.gmail.com>
References: <20171211144937.4537-1-marc.zyngier@arm.com>
 <20171211144937.4537-8-marc.zyngier@arm.com>
 <5A3020DA.8010309@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E562D49D1F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Dec 2017 18:37:45 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id W5lGfgMwjYyp for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Dec 2017 18:37:45 -0500 (EST)
Received: from mail-ot0-f170.google.com (mail-ot0-f170.google.com
 [74.125.82.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DBD3440651
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Dec 2017 18:37:44 -0500 (EST)
Received: by mail-ot0-f170.google.com with SMTP id p3so528025oti.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Dec 2017 15:41:15 -0800 (PST)
In-Reply-To: <5A3020DA.8010309@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: James Morse <james.morse@arm.com>
Cc: kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 12 December 2017 at 18:32, James Morse <james.morse@arm.com> wrote:
> As this is over my head, I've been pushing random encodings through gas/objdump
> and then tracing them through here.... can this encode 0xf80000000fffffff?
>
> gas thinks this is legal:
> |   0:   92458000        and     x0, x0, #0xf80000000fffffff
>
> I make that N=1, S=0x20, R=0x05.
> (I'm still working out what 'S' means)

This comment from QEMU (describing the decode direction, ie
immn,imms,immr => immediate) might assist:

    /* The bit patterns we create here are 64 bit patterns which
     * are vectors of identical elements of size e = 2, 4, 8, 16, 32 or
     * 64 bits each. Each element contains the same value: a run
     * of between 1 and e-1 non-zero bits, rotated within the
     * element by between 0 and e-1 bits.
     *
     * The element size and run length are encoded into immn (1 bit)
     * and imms (6 bits) as follows:
     * 64 bit elements: immn = 1, imms = <length of run - 1>
     * 32 bit elements: immn = 0, imms = 0 : <length of run - 1>
     * 16 bit elements: immn = 0, imms = 10 : <length of run - 1>
     *  8 bit elements: immn = 0, imms = 110 : <length of run - 1>
     *  4 bit elements: immn = 0, imms = 1110 : <length of run - 1>
     *  2 bit elements: immn = 0, imms = 11110 : <length of run - 1>
     * Notice that immn = 0, imms = 11111x is the only combination
     * not covered by one of the above options; this is reserved.
     * Further, <length of run - 1> all-ones is a reserved pattern.
     *
     * In all cases the rotation is by immr % e (and immr is 6 bits).
     */

so N=1 S=0x20 means run length 33, element size 64 (and
indeed your immediate has a run of 33 set bits).

(The Arm ARM pseudocode is confusing here because it merges
the handling of logical-immediates and bitfield instructions
together, which is nice if you're a hardware engineer. For
software you're much better off keeping the two separate.)

thanks
-- PMM
