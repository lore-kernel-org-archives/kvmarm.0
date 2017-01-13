From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [RFC 07/13] KVM: arm64: ITS: Change entry_size and indirect bit
 in BASER
Date: Fri, 13 Jan 2017 09:57:27 +0100
Message-ID: <89752a29-d533-1f4c-9e9b-93e8bd0556b3@redhat.com>
References: <1484236613-24633-1-git-send-email-eric.auger@redhat.com>
 <1484236613-24633-8-git-send-email-eric.auger@redhat.com>
 <dc26dc19-313b-375b-0d9b-f4ff411a914f@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DDCAC40421
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Jan 2017 03:55:46 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Mn6c7AHQ9PM9 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 Jan 2017 03:55:46 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3DC86403F8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Jan 2017 03:55:45 -0500 (EST)
In-Reply-To: <dc26dc19-313b-375b-0d9b-f4ff411a914f@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, eric.auger.pro@gmail.com, christoffer.dall@linaro.org, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, drjones@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: andre.przywara@arm.com, Prasun.Kapoor@cavium.com, dgilbert@redhat.com, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On 12/01/2017 18:05, Marc Zyngier wrote:
> On 12/01/17 15:56, Eric Auger wrote:
>> Change the device table entry_size to 16 bytes instead of 8.
>> We also Store the device and collection device in the its
>> struct.
>>
>> The patch also clears the indirect bit for the device BASER.
>> The indirect bit is set as read-only.
> 
> Err... Why? We *really* want to continue supporting indirect tables, as
> this is a massive memory saver for the guest.
> 
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>
>> ---
>>
>> TODO: investigate support of 2 level tables, ie. enabling
>> Indirect = 1. Support of 2 level tables is implementation
>> defined.
> 
> Clearly, that's a regression. What exactly is the issue that decided you
> to disable it?
Well no valuable reason besides I saw it was optional, lack of
time/knowledge and a bit of laziness. I will address this requirement in
my next respin.

For my curiosity why did we choose not allowing the feature for
collections. Is that just because we think their number if going
sufficiently small compared to devices?

Thanks

Eric
> 
> Thanks,
> 
> 	M.
> 
