From: Claudio Fontana <claudio.fontana-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] target-arm: kvm: Differentiate registers based on
 write-back levels
Date: Wed, 22 Jul 2015 18:09:22 +0200
Message-ID: <55AFC032.5000702@huawei.com>
References: <1437046488-10773-1-git-send-email-christoffer.dall@linaro.org> <CAFEAcA_cyXztq2E007cOjmm7usq_KNJ4AsUXRCkNwyETibcfqg@mail.gmail.com> <20150717153901.GD14024@cbox> <55AF92EB.9050909@huawei.com> <CAFEAcA8RNjyXBXXbTDSyNuh0E0gDDm8YOgRhci+RaAnuOeHDQg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <osv-dev+bncBAABBN4AX6WQKGQEIB3INRQ-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <CAFEAcA8RNjyXBXXbTDSyNuh0E0gDDm8YOgRhci+RaAnuOeHDQg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Post: <http://groups.google.com/group/osv-dev/post>, <mailto:osv-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/>, <mailto:osv-dev+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/osv-dev
Sender: osv-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/osv-dev/subscribe>, <mailto:osv-dev+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+701177940717+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <http://groups.google.com/group/osv-dev/subscribe>
To: Peter Maydell <peter.maydell-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, QEMU Developers <qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org>, "kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org" <kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org>, Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org>, Jan
 Kiszka <jan.kiszka-S0/GAf8tV78@public.gmane.org>, osv-dev <osv-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 22.07.2015 16:03, Peter Maydell wrote:
> On 22 July 2015 at 13:56, Claudio Fontana <claudio.fontana-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
>>
>> I can if you want check if this patch actually fixes the problem without the KVM workaround.
>> Is this the version I am supposed to test, or should I wait for the next respin?
> 
> Fixed version went into master earlier this week, so test that...
> 
> thanks
> -- PMM

Awesome, one week in vacation and it's done :-)

Anyway, tested and works ok, no more time jumps.

Thanks!

CLaudio
 
