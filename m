From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: Re: [PATCH kvmtool v2 4/6] arm: Support firmware loading
Date: Mon, 14 Jan 2019 09:50:54 +0000
Message-ID: <3156963c-8222-8063-8f1e-4e250eb7e503@arm.com>
References: <1547130046-14729-1-git-send-email-julien.thierry@arm.com>
 <1547130046-14729-5-git-send-email-julien.thierry@arm.com>
 <20190111180702.610a3114@donnerap.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F24BB4A401
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Jan 2019 04:50:59 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DksAeV6P-sbN for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Jan 2019 04:50:59 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EAE984A3D6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Jan 2019 04:50:58 -0500 (EST)
In-Reply-To: <20190111180702.610a3114@donnerap.cambridge.arm.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>, Julien Thierry <julien.thierry@arm.com>
Cc: Sami.Mujawar@arm.com, will.deacon@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 1/11/19 6:07 PM, Andre Przywara wrote:
> Does anyone know why we force a 2MB alignment (FDT_ALIGN) here? Will?

Is not it because early days fdt was mapped with a single 2M block mapping?

Vladimir
