From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v12 3/4] hw/arm/virt: add dynamic sysbus device support
Date: Mon, 27 Apr 2015 14:56:57 +0100
Message-ID: <CAFEAcA_2FYR3A6Y5oSACEQG6+W7CBJfFpxoDzLyxiqM-KQv6hg@mail.gmail.com>
References: <1429888773-11730-1-git-send-email-eric.auger@linaro.org>
 <1429888773-11730-4-git-send-email-eric.auger@linaro.org>
 <553E3C71.1040001@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9679F4E985
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Apr 2015 09:48:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vvvNG1nD2sj9 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Apr 2015 09:48:54 -0400 (EDT)
Received: from mail-ig0-f176.google.com (mail-ig0-f176.google.com
 [209.85.213.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C25D34E980
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Apr 2015 09:48:53 -0400 (EDT)
Received: by iget9 with SMTP id t9so69097212ige.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Apr 2015 06:57:17 -0700 (PDT)
In-Reply-To: <553E3C71.1040001@suse.de>
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

On 27 April 2015 at 14:41, Alexander Graf <agraf@suse.de> wrote:
> Peter, would you have a hard time if we just get rid of VIRT_MMIO completely
> and allow users to create the mmio-virtio bridges using -device for -M
> virt-2.4 and above?

I would strongly prefer not -- it breaks existing working command
lines. I agree that we are going to want to move to virtio-pci
and virtio-mmio is just legacy, but retaining legacy is what makes
QEMU not kvmtool, right? :-)

-- PMM
