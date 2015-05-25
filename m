From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [Qemu-devel] [PATCH v3 4/4] target-arm: Add the GICv2m to the
 virt board
Date: Mon, 25 May 2015 16:01:42 +0100
Message-ID: <CAFEAcA9QWKuh3zjXg_n3HiABEgoXaiRJ8sHMnj=uOzdMGF6yDQ@mail.gmail.com>
References: <1432464666-4825-1-git-send-email-christoffer.dall@linaro.org>
 <1432464666-4825-5-git-send-email-christoffer.dall@linaro.org>
 <011b01d096ec$1a395e80$4eac1b80$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E4CC51F3C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 May 2015 10:52:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id urorlnfMiZHK for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 May 2015 10:52:28 -0400 (EDT)
Received: from mail-ig0-f173.google.com (mail-ig0-f173.google.com
 [209.85.213.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E97FB51F22
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 May 2015 10:52:27 -0400 (EDT)
Received: by igbpi8 with SMTP id pi8so39326454igb.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 May 2015 08:02:03 -0700 (PDT)
In-Reply-To: <011b01d096ec$1a395e80$4eac1b80$@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Pavel Fedin <p.fedin@samsung.com>
Cc: QEMU Developers <qemu-devel@nongnu.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 25 May 2015 at 14:09, Pavel Fedin <p.fedin@samsung.com> wrote:
>  Hello!
>
>>  typedef struct MemMapEntry {
>> @@ -88,6 +90,7 @@ typedef struct VirtBoardInfo {
>>      int fdt_size;
>>      uint32_t clock_phandle;
>>      uint32_t gic_phandle;
>> +    uint32_t v2m_phandle;
>>  } VirtBoardInfo;
>
>  Could you rename v2m_phandle to something more neutral like msi_phandle ? It will also be
> used by GICv3 ITS implementation.

Why? The v2m device isn't really related to the GICv3...

-- PMM
