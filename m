From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 05/45] KVM: arm/arm64: vgic-new: Add acccessor to new
 struct vgic_irq instance
Date: Tue, 26 Apr 2016 09:21:30 +0100
Message-ID: <571F250A.2040507@arm.com>
References: <1460740316-8755-1-git-send-email-andre.przywara@arm.com>
 <1460740316-8755-6-git-send-email-andre.przywara@arm.com>
 <20160425161525.b4hqjrrharfdsdgo@hawk.localdomain>
 <20160425194901.GM16590@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160425194901.GM16590@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, Andrew Jones <drjones@redhat.com>
Cc: Andre Przywara <andre.przywara@arm.com>, Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 25/04/16 20:49, Christoffer Dall wrote:
> On Mon, Apr 25, 2016 at 06:15:25PM +0200, Andrew Jones wrote:
>> Hi Andre,
>>
>> I'm just randomly jumping in here because I spotted a typo in $SUBJECT.
>> 'accessor' has too many c's. Also, just curious, but if the author is
>> from Linaro (hi Christoffer), then why do the new files this patch adds
>> have ARM copyrights?
>>
> 
> We just decided to let ARM deal with asserting the license since we all
> collaborated on it, but others also suggested that we should let ARM and
> Linaro share the license.

I personally have no objections to having both ARM and Linaro sharing
the copyright, but I just don't know how this works in practice (and
asking any legal department is a sure recipe to delay these patches for
an extra 6 months, give or take a few years).

In the end, all I care about is the licence under which the code is
released.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
