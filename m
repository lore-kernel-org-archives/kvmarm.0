From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v12 3/4] hw/arm/virt: add dynamic sysbus device support
Date: Mon, 27 Apr 2015 18:10:23 +0100
Message-ID: <CAFEAcA9Smw0vGSDOHmzB73r0K1uxsxGkUOLCKxwRTPBrYScA1w@mail.gmail.com>
References: <1429888773-11730-1-git-send-email-eric.auger@linaro.org>
 <1429888773-11730-4-git-send-email-eric.auger@linaro.org>
 <553E3C71.1040001@suse.de>
 <553E6ABB.1070703@codeaurora.org> <553E6C04.1050805@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D6254E982
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Apr 2015 13:02:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 80Uw-JZPkJ9y for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Apr 2015 13:02:19 -0400 (EDT)
Received: from mail-ig0-f176.google.com (mail-ig0-f176.google.com
 [209.85.213.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 63EDA4E97E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Apr 2015 13:02:18 -0400 (EDT)
Received: by iget9 with SMTP id t9so72614240ige.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Apr 2015 10:10:43 -0700 (PDT)
In-Reply-To: <553E6C04.1050805@suse.de>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alexander Graf <agraf@suse.de>
Cc: eric.auger@st.com, Patch Tracking <patches@linaro.org>, QEMU Developers <qemu-devel@nongnu.org>, Alex Williamson <alex.williamson@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 27 April 2015 at 18:04, Alexander Graf <agraf@suse.de> wrote:
> On 04/27/2015 06:58 PM, Christopher Covington wrote:
>> I'm not sure I have an opinion one way or the other, but I would like to
>> understand the "big waste" argument. Is there something that users are
>> eager
>> to reuse this address space for, like more RAM?
>
>
> It will get used for platform device assignment. If we only reserve 32MB we
> will quickly run out of address space to map devices into.

Personally I am hoping that platform device assignment will
also turn out to be mostly for legacy reasons and anybody
wanting to do serious device passthrough will be doing it with
PCI...

-- PMM
