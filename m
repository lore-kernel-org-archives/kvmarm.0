From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [Qemu-devel] [PATCH v3 4/4] target-arm: Add the GICv2m to the
 virt board
Date: Mon, 25 May 2015 18:25:49 +0200
Message-ID: <55634D0D.3010103@linaro.org>
References: <1432464666-4825-1-git-send-email-christoffer.dall@linaro.org>
 <1432464666-4825-5-git-send-email-christoffer.dall@linaro.org>
 <011b01d096ec$1a395e80$4eac1b80$@samsung.com>
 <CAFEAcA9QWKuh3zjXg_n3HiABEgoXaiRJ8sHMnj=uOzdMGF6yDQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A211951FCF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 May 2015 12:16:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6th7DbicnRSA for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 May 2015 12:16:22 -0400 (EDT)
Received: from mail-wg0-f49.google.com (mail-wg0-f49.google.com [74.125.82.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7F18951FC0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 May 2015 12:16:22 -0400 (EDT)
Received: by wgbgq6 with SMTP id gq6so76623907wgb.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 May 2015 09:25:59 -0700 (PDT)
In-Reply-To: <CAFEAcA9QWKuh3zjXg_n3HiABEgoXaiRJ8sHMnj=uOzdMGF6yDQ@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Peter Maydell <peter.maydell@linaro.org>, Pavel Fedin <p.fedin@samsung.com>
Cc: QEMU Developers <qemu-devel@nongnu.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 05/25/2015 05:01 PM, Peter Maydell wrote:
> On 25 May 2015 at 14:09, Pavel Fedin <p.fedin@samsung.com> wrote:
>>  Hello!
>>
>>>  typedef struct MemMapEntry {
>>> @@ -88,6 +90,7 @@ typedef struct VirtBoardInfo {
>>>      int fdt_size;
>>>      uint32_t clock_phandle;
>>>      uint32_t gic_phandle;
>>> +    uint32_t v2m_phandle;
>>>  } VirtBoardInfo;
>>
>>  Could you rename v2m_phandle to something more neutral like msi_phandle ? It will also be
>> used by GICv3 ITS implementation.
> 
> Why? The v2m device isn't really related to the GICv3...
In the future this handle could point to GICv2m or GICv3 ITS or GICv3
(if I understand it correctly, when it supports message base interrupts
and no ITS). They all would play the same role of msi-controller.

Best Regards

Eric
> 
> -- PMM
> 
