From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH] arm64: KVM: Enable minimalistic support for Thunder
Date: Mon, 29 Jun 2015 18:17:51 +0100
Message-ID: <CAFEAcA-uDyWko_TA+thCqZ-N8200n9b_ACcSQZvw1QX-PWCLBg@mail.gmail.com>
References: <1435348284-32132-1-git-send-email-tchalamarla@caviumnetworks.com>
 <55910794.6000107@arm.com>
 <AED13EAB-D578-451F-AC35-A45A21816076@caviumnetworks.com>
 <55917C31.4060107@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D40E356A27
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Jun 2015 13:07:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id P6j7oreeBQKq for <kvmarm@lists.cs.columbia.edu>;
 Mon, 29 Jun 2015 13:07:01 -0400 (EDT)
Received: from mail-vn0-f50.google.com (mail-vn0-f50.google.com
 [209.85.216.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 01A8F56A1C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Jun 2015 13:07:00 -0400 (EDT)
Received: by vnbf129 with SMTP id f129so10492961vnb.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Jun 2015 10:18:11 -0700 (PDT)
In-Reply-To: <55917C31.4060107@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Andre Przywara <Andre.Przywara@arm.com>, Will Deacon <Will.Deacon@arm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "rrichter@cavium.com" <rrichter@cavium.com>, "Chalamarla,
 Tirumalesh" <Tirumalesh.Chalamarla@caviumnetworks.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 29 June 2015 at 18:11, Marc Zyngier <marc.zyngier@arm.com> wrote:
> On 29/06/15 18:06, Chalamarla, Tirumalesh wrote:
>>
>>> On Jun 29, 2015, at 1:53 AM, Marc Zyngier <marc.zyngier@arm.com> wrote:
>>> Constantly adding new CPUs without providing any insight as to how they
>>> should be emulated only brings churn, and not much benefit.
>>>
>> we are not planning(at this point) to emulate Thunder with QEMU/others.
>
> Fair enough. If cross-cpu VM migration is none of your concern, then
> Suzuki's patch should be enough.

"Emulate with QEMU" is a completely different thing from
"support cross-cpu VM migration" !

-- PMM
