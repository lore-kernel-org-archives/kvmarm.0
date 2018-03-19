From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: [PATCH v2 0/7] KASan for arm
Date: Mon, 19 Mar 2018 09:43:48 +0100
Message-ID: <CACT4Y+bec8x8AZOneZ57bnxei=gBGGKG2_VUiqyMaa1OPzov2g@mail.gmail.com>
References: <B8AC3E80E903784988AB3003E3E97330C0076FFD@dggemm510-mbs.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <B8AC3E80E903784988AB3003E3E97330C0076FFD@dggemm510-mbs.china.huawei.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: "Liuwenliang (Abbott Liu)" <liuwenliang@huawei.com>
Cc: "kstewart@linuxfoundation.org" <kstewart@linuxfoundation.org>, "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>, "grygorii.strashko@linaro.org" <grygorii.strashko@linaro.org>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, "tixy@linaro.org" <tixy@linaro.org>, "linux@rasmusvillemoes.dk" <linux@rasmusvillemoes.dk>, "dhowells@redhat.com" <dhowells@redhat.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "glider@google.com" <glider@google.com>, "mark.rutland@arm.com" <mark.rutland@arm.com>, "afzal.mohd.ma@gmail.com" <afzal.mohd.ma@gmail.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Florian Fainelli <f.fainelli@gmail.com>, "mawilcox@microsoft.com" <mawilcox@microsoft.com>, "linux@armlinux.org.uk" <linux@armlinux.org.uk>, "kasan-dev@googlegroups.com" <kasan-dev@googlegroups.com>, "geert@linux-m68k.org" <geert@linux-m68k.org>, zhichao.huang
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Mar 19, 2018 at 2:56 AM, Liuwenliang (Abbott Liu)
<liuwenliang@huawei.com> wrote:
> On 03/19/2018 09:23 AM, Florian Fainelli wrote:
>>On 03/18/2018 06:20 PM, Liuwenliang (Abbott Liu) wrote:
>>> On 03/19/2018 03:14 AM, Florian Fainelli wrote:
>>>> Thanks for posting these patches! Just FWIW, you cannot quite add
>>>> someone's Tested-by for a patch series that was just resubmitted given
>>>> the differences with v1. I just gave it a spin on a Cortex-A5 (no LPAE)
>>>> and it looks like test_kasan.ko is passing, great job!
>>>
>>> I'm sorry.
>>> Thanks for your testing very much!
>>> I forget to add Tested-by in cover letter patch file. But I have alreadly added
>>> Tested-by in some of following patch.
>>> In the next version I am going to add Tested-by in all patches.
>>
>>This is not exactly what I meant. When you submit a v2 of your patches,
>>you must wait for people to give you their test results. The Tested-by
>>applied to v1, and so much has changed it is no longer valid for v2
>>unless someone tells you they tested v2. Hope this is clearer.
>
> Ok, I understand now. thank you for your explanation.


Hi Abbott,

I've skimmed through the changes and they generally look good to me. I
am not an expect in arm, so I did not look too closely on these parts
(which is actually most of the changes).

FWIW
Acked-by: Dmitry Vyukov <dvyukov@google.com>

Please also update set of supported archs at the top of
Documentation/dev-tools/kasan.rst

Thanks for working on upstreaming this!
