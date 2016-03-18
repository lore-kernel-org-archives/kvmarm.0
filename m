From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v3 00/16] KVM: arm64: GICv3 ITS emulation
Date: Fri, 18 Mar 2016 17:14:24 +0000
Message-ID: <CAFEAcA95vZD0NvvE5WOKjEdYtebY+gjhDxk+PH5KSG9A8GgRiw@mail.gmail.com>
References: <1444229726-31559-1-git-send-email-andre.przywara@arm.com>
 <56E00A7E.4080101@semihalf.com> <20160313181608.GA15988@cbox>
 <56E69CCA.5070407@arm.com> <CAFEAcA8r5LDbNG0XVnHnsoYcrfcpfnR3FQ_u=-L7Dop1HFVgxw@mail.gmail.com>
 <56E6FAEB.1090306@arm.com> <56E700F4.4060308@arm.com> <20160318094029.GC10806@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160318094029.GC10806@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Andre Przywara <andre.przywara@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Tomasz Nowicki <tn@semihalf.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, kvm-devel <kvm@vger.kernel.org>, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 18 March 2016 at 09:40, Christoffer Dall <christoffer.dall@linaro.org> wrote:
> On Mon, Mar 14, 2016 at 06:20:36PM +0000, Andre Przywara wrote:
>> Well, probably there is not so much difference. I was just wondering if
>> it would be easier to treat that data as an opaque blob.
>> But you are probably right that it would just mean the difference
>> between documenting the format or not.

> Even ignoring the migrate-to-TCG case, you cannot treat it as a blob,
> because you want to be able to migrate between KVM on kernel version X
> and version Y.

You could require userspace to treat it as an opaque blob, and
transparently handle any version-upgrade within the kernel.
I think having it be documented-to-userspace ABI makes it
clearer that any format changes are a Big Deal, though.

thanks
-- PMM
