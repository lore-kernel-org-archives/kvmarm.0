From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 0/2] KVM: arm/arm64: Clean up some obsolete code
Date: Thu, 08 Oct 2015 11:56:04 +0100
Message-ID: <56164BC4.80104@arm.com>
References: <cover.1443796321.git.p.fedin@samsung.com>
 <20151008101408.GA20936@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AF66241300
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Oct 2015 06:54:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ypWbtiIshaXo for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Oct 2015 06:54:07 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C4A21412F3
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Oct 2015 06:54:07 -0400 (EDT)
In-Reply-To: <20151008101408.GA20936@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, Pavel Fedin <p.fedin@samsung.com>
Cc: Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 08/10/15 11:14, Christoffer Dall wrote:
> Hi Pavel,
> =

> On Fri, Oct 02, 2015 at 05:44:27PM +0300, Pavel Fedin wrote:
>> Current KVM code has lots of old redundancies, which can be cleaned up.
>> This patchset is actually a better alternative to
>> http://www.spinics.net/lists/arm-kernel/msg430726.html, which allows to
>> keep piggy-backed LRs. The idea is based on the fact that our code also
>> maintains LR state in elrsr, and this information is enough to track LR
>> usage.
>>
>> This patchset is made against linux-next of 02.10.2015. Thanks to Andre
>> for pointing out some 4.3 specifics.
>>
> I'm not opposed to these changes, they clean up the data structures
> which is definitely a good thing.
> =

> I am a bit worries about how/if this is going to conflict with the ITS
> series and other patches in flight touchignt he vgic.
> =

> Marc/Andre, any thoughts on this?

I don't mind the simplification (Andre was already removing the
piggybacking stuff as part of his ITS series). I'm a bit more cautious
about the sync_elrsr stuff, but that's mostly because I've only read the
patch in a superficial way.

But yes, this is probably going to clash, unless we make this part of an
existing series (/me looks at Andr=E9... ;-)

	M.
-- =

Jazz is not dead. It just smells funny...
