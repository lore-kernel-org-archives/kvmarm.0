From: Tianyu Lan <lantianyu1986@gmail.com>
Subject: Re: [PATCH V3 1/10] X86/Hyper-V: Add parameter offset for
 hyperv_fill_flush_guest_mapping_list()
Date: Tue, 26 Feb 2019 21:00:03 +0800
Message-ID: <CAOLK0pzVwH-1pObn3FjmLorc_pjLu2q0Q_EG4iYm3yb2aXL7PQ@mail.gmail.com>
References: <20190222150637.2337-1-Tianyu.Lan@microsoft.com>
 <20190222150637.2337-2-Tianyu.Lan@microsoft.com>
 <SN6PR2101MB0912C24CD03D22248C868196CC7F0@SN6PR2101MB0912.namprd21.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 67D444A1DF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Feb 2019 08:00:16 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JfcSVsYBxygV for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Feb 2019 08:00:15 -0500 (EST)
Received: from mail-pl1-f196.google.com (mail-pl1-f196.google.com
 [209.85.214.196])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6ADB049E3E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Feb 2019 08:00:15 -0500 (EST)
Received: by mail-pl1-f196.google.com with SMTP id v11so798002plg.9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Feb 2019 05:00:15 -0800 (PST)
In-Reply-To: <SN6PR2101MB0912C24CD03D22248C868196CC7F0@SN6PR2101MB0912.namprd21.prod.outlook.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Stephen Hemminger <sthemmin@microsoft.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, "will.deacon@arm.com" <will.deacon@arm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "paulus@ozlabs.org" <paulus@ozlabs.org>, "hpa@zytor.com" <hpa@zytor.com>, KY Srinivasan <kys@microsoft.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "sashal@kernel.org" <sashal@kernel.org>, "mpe@ellerman.id.au" <mpe@ellerman.id.au>, "x86@kernel.org" <x86@kernel.org>, "linux@armlinux.org.uk" <linux@armlinux.org.uk>, "mingo@redhat.com" <mingo@redhat.com>, "benh@kernel.crashing.org" <benh@kernel.crashing.org>, "jhogan@kernel.org" <jhogan@kernel.org>, "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>, Tianyu Lan <Tianyu.Lan@microsoft.com>, "marc.zyngier@arm.com" <marc.zyngier@arm.com>, Haiyang Zhang <haiyangz@microsoft.com>, kvm-ppc@vger
List-Id: kvmarm@lists.cs.columbia.edu

Hi Stephen:
               Thanks for your review.
On Sat, Feb 23, 2019 at 1:08 AM Stephen Hemminger
<sthemmin@microsoft.com> wrote:
>
> int hyperv_fill_flush_guest_mapping_list(
>                 struct hv_guest_mapping_flush_list *flush,
> -               u64 start_gfn, u64 pages)
> +               int offset, u64 start_gfn, u64 pages)
>  {
>         u64 cur = start_gfn;
>         u64 additional_pages;
> -       int gpa_n = 0;
> +       int gpa_n = offset;
>
>         do {
>                 /*
>
> Do you mean to support negative offsets here? Maybe unsigned would be better?

Yes, this makes sense. Will update. Thanks.

-- 
Best regards
Tianyu Lan
