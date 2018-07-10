From: alan@wylie.me.uk (Alan J. Wylie)
Subject: Re: [PATCH 0/2] arm64: spectre-v1 write fixes (CVE-2018-3693)
Date: Tue, 10 Jul 2018 20:28:04 +0100
Message-ID: <87d0vuao1n.fsf@wylie.me.uk>
References: <20180710180123.56461-1-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180710180123.56461-1-mark.rutland@arm.com> (Mark Rutland's
 message of "Tue, 10 Jul 2018 19:01:21 +0100")
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Mark Rutland <mark.rutland@arm.com>
Cc: marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, christoffer.dall@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Mark Rutland <mark.rutland@arm.com> writes:

> These patches inhibit spectre-v1-write gadgets found in arch/arm64, using the
> same mitigation applied to existing spectre-v1-read gadgets.
>
> This issue is also known as CVE-2018-3693, or "bounds check bypass store".
> More details can be found in the Arm Cache Speculation Side-channels
> whitepaper, available from the Arm security updates site [1].

> [1] https://developer.arm.com/support/arm-security-updates/speculative-processor-vulnerability

>From that web page:

| Variant 1: bounds check bypass store (CVE-2017-5753) and bounds check
| bypass store (CVE-2018-3693)

Isn't -5753 a "read" vulnerability, not "store"?

-- 
Alan J. Wylie                                          https://www.wylie.me.uk/

Dance like no-one's watching. / Encrypt like everyone is.
Security is inversely proportional to convenience
