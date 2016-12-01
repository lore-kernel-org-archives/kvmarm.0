From: =?UTF-8?Q?Andr=c3=a9_Przywara?= <andre.przywara@arm.com>
Subject: Re: [kvm-unit-tests PATCH v13 4/4] arm: pmu: Add CPI checking
Date: Thu, 1 Dec 2016 22:04:18 +0000
Message-ID: <9e8de357-c1f2-ec44-440d-2b3b7e4ffeb6@arm.com>
References: <1480569402-8848-1-git-send-email-wei@redhat.com>
 <1480569402-8848-5-git-send-email-wei@redhat.com>
 <0ff887b9-3e72-87aa-e077-7c78b3073dbe@arm.com>
 <1b3b7bd6-3e53-9d71-d177-933c5a606c16@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1b3b7bd6-3e53-9d71-d177-933c5a606c16@codeaurora.org>
Sender: kvm-owner@vger.kernel.org
To: Christopher Covington <cov@codeaurora.org>, Wei Huang <wei@redhat.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, shannon.zhao@linaro.org, alistair.francis@xilinx.com, croberts@codeaurora.org, alindsay@codeaurora.org, drjones@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On 01/12/16 21:18, Christopher Covington wrote:
> On 12/01/2016 03:27 PM, Andre Przywara wrote:

Hi,

....

>>> +		}
>>> +		avg = sum / NR_SAMPLES;
>>> +		printf(" sum=%"PRId64" avg=%"PRId64" avg_ipc=%"PRId64" "
>>> +		       "avg_cpi=%"PRId64"\n", sum, avg, i / avg, avg / i);
>>
>>                 printf(" avg=%4"PRId64": %3"PRId64" %s\n",
>>                        sum / NR_SAMPLES, i > avg ? i / avg : avg / i,
>>                        i > avg ? "ipc" : "cpi");
>>
>> In general I question the usefulness of the cpi/ipc output, it didn't
>> seem meaningful in any way to me, neither in KVM or in TCG.
>> See the last line (68: ...) in the example above, we shouldn't use an
>> average with that deviation for statistical purposes.
>> For KVM I get values ranging from 60 to 4383 cpi, which doesn't convey
>> any real information to me, in fact the actual cycles look like constant
>> to me, probably due to emulation overhead.
>>
>> So what are we supposed to learn from those numbers?
> 
> I think they were mostly useful in debugging the checking of TCG's
> -icount mode, where the numbers are precise.
> 
> I think seeing variable numbers from TCG when -icount is off illustrates
> why -icount is useful. But justifying TCG best practices is a non-goal of
> kvm-unit-tests.
> 
> I'd like to think is possible to see anomalies in the KVM info which are
> due to bugs, but perhaps that's unrealistic or unlikely.
> 
> Feel free to drop the prints, or only print in -icount mode, or only print
> when there's error in -icount mode.

No, it's totally fine to keep them, especially since they only appear
when one runs a test manually.

So thanks for the explanation, those numbers _are_ useful, it was just
me being clueless and/or ignorant ;-)

Cheers,
Andre

P.S. It looks like we should have some documentation, explaining these
numbers, for instance, and the expected results. Along with explanations
what all the other tests do, possibly with pointers where to look for in
case of failures. </enthusiasm>
And no, I am not volunteering, at least not for the PMU ...

