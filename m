Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E257FC433FE
	for <kvmarm@archiver.kernel.org>; Wed, 19 Oct 2022 06:31:10 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 40D3C4B8FA;
	Wed, 19 Oct 2022 02:31:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id w15685igtTSs; Wed, 19 Oct 2022 02:31:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AC3064B90D;
	Wed, 19 Oct 2022 02:31:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A9D5F4B7CF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Oct 2022 13:34:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NgBiGHZDUYLi for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Oct 2022 13:34:52 -0400 (EDT)
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AEDC64B796
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Oct 2022 13:34:52 -0400 (EDT)
Received: from MUA by vps-vb.mhejs.net with esmtps (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94.2)
 (envelope-from <mail@maciej.szmigiero.name>)
 id 1okU0m-0001Ml-UB; Mon, 17 Oct 2022 19:34:48 +0200
Message-ID: <fb3926da-a683-2811-71a4-31fe36a9cb50@maciej.szmigiero.name>
Date: Mon, 17 Oct 2022 19:34:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Content-Language: en-US, pl-PL
To: Gavin Shan <gshan@redhat.com>
References: <20221014071914.227134-1-gshan@redhat.com>
 <20221014071914.227134-4-gshan@redhat.com>
From: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH 3/6] KVM: selftests: memslot_perf_test: Probe memory slots
 for once
In-Reply-To: <20221014071914.227134-4-gshan@redhat.com>
X-Mailman-Approved-At: Wed, 19 Oct 2022 02:31:08 -0400
Cc: kvm@vger.kernel.org, maz@kernel.org, linux-kernel@vger.kernel.org,
 zhenyzha@redhat.com, shan.gavin@gmail.com, kvmarm@lists.linux.dev,
 pbonzini@redhat.com, shuah@kernel.org, kvmarm@lists.cs.columbia.edu,
 ajones@ventanamicro.com
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 14.10.2022 09:19, Gavin Shan wrote:
> prepare_vm() is called in every iteration and run. The allowed memory
> slots (KVM_CAP_NR_MEMSLOTS) are probed for multiple times. It's not
> free and unnecessary.
> 
> Move the probing logic for the allowed memory slots to parse_args()
> for once, which is upper layer of prepare_vm().
> 
> No functional change intended.
> 
> Signed-off-by: Gavin Shan <gshan@redhat.com>
> ---
>   .../testing/selftests/kvm/memslot_perf_test.c | 29 ++++++++++---------
>   1 file changed, 16 insertions(+), 13 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/memslot_perf_test.c b/tools/testing/selftests/kvm/memslot_perf_test.c
> index dcb492b3f27b..d5aa9148f96f 100644
> --- a/tools/testing/selftests/kvm/memslot_perf_test.c
> +++ b/tools/testing/selftests/kvm/memslot_perf_test.c
> @@ -245,27 +245,17 @@ static bool prepare_vm(struct vm_data *data, int nslots, uint64_t *maxslots,
>   		       void *guest_code, uint64_t mempages,
>   		       struct timespec *slot_runtime)
>   {
> -	uint32_t max_mem_slots;
>   	uint64_t rempages;
>   	uint64_t guest_addr;
>   	uint32_t slot;
>   	struct timespec tstart;
>   	struct sync_area *sync;
>   
> -	max_mem_slots = kvm_check_cap(KVM_CAP_NR_MEMSLOTS);
> -	TEST_ASSERT(max_mem_slots > 1,
> -		    "KVM_CAP_NR_MEMSLOTS should be greater than 1");
> -	TEST_ASSERT(nslots > 1 || nslots == -1,
> -		    "Slot count cap should be greater than 1");
> -	if (nslots != -1)
> -		max_mem_slots = min(max_mem_slots, (uint32_t)nslots);
> -	pr_info_v("Allowed number of memory slots: %"PRIu32"\n", max_mem_slots);
> -
>   	TEST_ASSERT(mempages > 1,
>   		    "Can't test without any memory");
>   
>   	data->npages = mempages;
> -	data->nslots = max_mem_slots - 1;
> +	data->nslots = nslots;
>   	data->pages_per_slot = mempages / data->nslots;
>   	if (!data->pages_per_slot) {
>   		*maxslots = mempages + 1;
> @@ -885,8 +875,8 @@ static bool parse_args(int argc, char *argv[],
>   			break;
>   		case 's':
>   			targs->nslots = atoi(optarg);
> -			if (targs->nslots <= 0 && targs->nslots != -1) {
> -				pr_info("Slot count cap has to be positive or -1 for no cap\n");
> +			if (targs->nslots <= 1 && targs->nslots != -1) {
> +				pr_info("Slot count cap must be larger than 1 or -1 for no cap\n");
>   				return false;
>   			}
>   			break;
> @@ -932,6 +922,19 @@ static bool parse_args(int argc, char *argv[],
>   		return false;
>   	}
>   
> +	/* Memory slot 0 is reserved */
> +	if (targs->nslots == -1) {
> +		targs->nslots = kvm_check_cap(KVM_CAP_NR_MEMSLOTS) - 1;
> +		if (targs->nslots < 1) {
> +			pr_info("KVM_CAP_NR_MEMSLOTS should be greater than 1\n");
> +			return false;
> +		}
> +	} else {
> +		targs->nslots--;
> +	}
> +
> +	pr_info_v("Number of memory slots: %d\n", targs->nslots);
> +

Can't see any capping of the command line provided slot count to
KVM_CAP_NR_MEMSLOTS value, like the old code did.

>   	return true;
>   }
>   

Thanks,
Maciej

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
