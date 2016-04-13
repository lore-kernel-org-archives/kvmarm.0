From: Hanjun Guo <hanjun.guo@linaro.org>
Subject: Re: [PATCH v6 05/10] irqchip/gic-v3: Prefix all pr_* messages by
 "GICv3: "
Date: Wed, 13 Apr 2016 18:01:48 +0800
Message-ID: <570E190C.8020203@linaro.org>
References: <1460388780-914-1-git-send-email-julien.grall@arm.com>
 <1460388780-914-6-git-send-email-julien.grall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 63B3649B3C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Apr 2016 06:00:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hTAkZ0iYDlYY for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Apr 2016 06:00:20 -0400 (EDT)
Received: from mail-pa0-f44.google.com (mail-pa0-f44.google.com
 [209.85.220.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 07915412C2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Apr 2016 06:00:19 -0400 (EDT)
Received: by mail-pa0-f44.google.com with SMTP id ot11so30917607pab.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Apr 2016 03:02:00 -0700 (PDT)
In-Reply-To: <1460388780-914-6-git-send-email-julien.grall@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Julien Grall <julien.grall@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: al.stone@linaro.org, kvm@vger.kernel.org, marc.zyngier@arm.com, linux-kernel@vger.kernel.org, fu.wei@linaro.org, linux-arm-kernel@lists.infradead.org, gg@slimlogic.co.uk
List-Id: kvmarm@lists.cs.columbia.edu

On 2016/4/11 23:32, Julien Grall wrote:
> Currently, most of the pr_* messages in the GICv3 driver don't have a
> prefix.  Add one to make clear where the messages come from.
>
> Signed-off-by: Julien Grall <julien.grall@arm.com>
>
> ---
>      Changes in v6:
>          - Patch added
> ---
>   drivers/irqchip/irq-gic-v3.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
> index 5b7d3c2..6dc6f03 100644
> --- a/drivers/irqchip/irq-gic-v3.c
> +++ b/drivers/irqchip/irq-gic-v3.c
> @@ -15,6 +15,8 @@
>    * along with this program.  If not, see <http://www.gnu.org/licenses/>.
>    */
>
> +#define pr_fmt(fmt)	"GICv3: " fmt

I don't think this patch is needed, as GICv3 and GICv2 will
not be probed at the same time, did I miss something?

Further more, there are prefixes in pr_fmt in this
patch using GIC:, with your patch added, it will print:

GIV3: GIC: .....

which is not a good idea.

Thanks
Hanjun
